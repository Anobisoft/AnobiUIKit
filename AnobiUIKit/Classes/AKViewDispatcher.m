//
//  AKViewDispatcher.m
//  ASUtilities
//
//  Created by Stanislav Pletnev on 2017-03-04
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKViewDispatcher.h"
#import <objc/runtime.h>

@interface AKViewDispatcher(private)
+ (void)viewDidLoadViewController:(UIViewController *)viewController;
+ (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController;
+ (void)viewDidAppear:(BOOL)animated viewController:(UIViewController *)viewController;
+ (void)viewWillDisappear:(BOOL)animated viewController:(UIViewController *)viewController;
+ (void)viewDidDisappear:(BOOL)animated viewController:(UIViewController *)viewController;
@end

@implementation UIViewController(Swizzled)

- (void)swizzledDidLoad {
    [AKViewDispatcher viewDidLoadViewController:self];
    [self swizzledDidLoad];
}

- (void)swizzledWillAppear:(BOOL)animated {
    [AKViewDispatcher viewWillAppear:animated viewController:self];
    [self swizzledWillAppear:animated];
}

- (void)swizzledDidAppear:(BOOL)animated {
    [AKViewDispatcher viewDidAppear:animated viewController:self];
    [self swizzledDidAppear:animated];
}

- (void)swizzledWillDisappear:(BOOL)animated {
    [AKViewDispatcher viewWillDisappear:animated viewController:self];
    [self swizzledWillDisappear:animated];
}

- (void)swizzledDidDisappear:(BOOL)animated {
    [AKViewDispatcher viewDidDisappear:animated viewController:self];
    [self swizzledDidDisappear:animated];
}

@end



@implementation AKViewDispatcher


+ (void)viewDidLoadViewController:(UIViewController *)viewController {
    for (id<AKViewObserver> observer in viewObservers) {
        if (observer && [observer respondsToSelector:@selector(viewDidLoadViewController:)])
            [observer viewDidLoadViewController:viewController];
    }
}
+ (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController {
    for (id<AKViewObserver> observer in viewObservers) {
        if (observer && [observer respondsToSelector:@selector(viewWillAppear:viewController:)])
            [observer viewWillAppear:animated viewController:viewController];
    }
}
+ (void)viewDidAppear:(BOOL)animated viewController:(UIViewController *)viewController {
    for (id<AKViewObserver> observer in viewObservers) {
        if (observer && [observer respondsToSelector:@selector(viewDidAppear:viewController:)])
            [observer viewDidAppear:animated viewController:viewController];
    }
}
+ (void)viewWillDisappear:(BOOL)animated viewController:(UIViewController *)viewController {
    for (id<AKViewObserver> observer in viewObservers) {
        if (observer && [observer respondsToSelector:@selector(viewWillDisappear:viewController:)])
            [observer viewWillDisappear:animated viewController:viewController];
    }
}
+ (void)viewDidDisappear:(BOOL)animated viewController:(UIViewController *)viewController {
    for (id<AKViewObserver> observer in viewObservers) {
        if (observer && [observer respondsToSelector:@selector(viewDidDisappear:viewController:)])
            [observer viewDidDisappear:animated viewController:viewController];
    }
}

static NSPointerArray *viewObservers;

+ (void)initialize {
    [super initialize];
    viewObservers = [NSPointerArray weakObjectsPointerArray];
}

+ (void)class:(Class)c swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(c, originalSelector);
    Method swizzledMethod = class_getInstanceMethod([UIViewController class], swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(c,
                    swizzledSelector,
                    method_getImplementation(originalMethod),
                    method_getTypeEncoding(originalMethod));
    
    if (didAddMethod) {
        class_replaceMethod(c,
                            originalSelector,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
    }
    
}

+ (void)addViewObserver:(id <AKViewObserver>)viewObserver {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray <NSString *> *classNames = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AKViewDispatcherConfig.plist"]][@"DispatchedViewControllers"];
        for (NSString *className in classNames) {
            Class c = NSClassFromString(className);
            if (c) {
                [self class:c swizzleSelector:@selector(viewDidLoad) withSelector:@selector(swizzledDidLoad)];
                [self class:c swizzleSelector:@selector(viewWillAppear:) withSelector:@selector(swizzledWillAppear:)];
                [self class:c swizzleSelector:@selector(viewDidAppear:) withSelector:@selector(swizzledDidAppear:)];
                [self class:c swizzleSelector:@selector(viewWillDisappear:) withSelector:@selector(swizzledWillDisappear:)];
                [self class:c swizzleSelector:@selector(viewDidDisappear:) withSelector:@selector(swizzledDidDisappear:)];
            }
        }
    });
    [viewObservers addPointer:(__bridge void * _Nullable)(viewObserver)];
}

+ (void)removeViewObserver:(id <AKViewObserver>)viewObserver {
    NSUInteger indx = 0;
    for (; indx < viewObservers.count; indx++) {
        if ([viewObservers pointerAtIndex:indx] == (__bridge void * _Nullable)(viewObserver)) break;
    }
    if (indx < viewObservers.count) [viewObservers removePointerAtIndex:indx];
}

+ (UIViewController *)visibleViewController {
    return [self visibleViewControllerFrom:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)visibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self visibleViewControllerFrom:((UINavigationController *)vc).visibleViewController];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self visibleViewControllerFrom:((UITabBarController *)vc).selectedViewController];
    } else {
        if (vc.presentedViewController) {
            return [self visibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

@end
