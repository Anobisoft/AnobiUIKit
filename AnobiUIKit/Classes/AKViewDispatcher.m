//
//  AKViewDispatcher.m
//  ASUtilities
//
//  Created by Stanislav Pletnev on 2017-03-04
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKViewDispatcher.h"
#import <objc/runtime.h>

@implementation AKViewDispatcher

- (void)swizzledDidLoad {
    [AKViewDispatcher viewDidLoadViewController:(UIViewController *)self];
    [self swizzledDidLoad];
}

- (void)swizzledWillAppear:(BOOL)animated {
    [AKViewDispatcher viewWillAppear:animated viewController:(UIViewController *)self];
    [self swizzledWillAppear:animated];
}

- (void)swizzledDidAppear:(BOOL)animated {
    [AKViewDispatcher viewDidAppear:animated viewController:(UIViewController *)self];
    [self swizzledDidAppear:animated];
}

- (void)swizzledWillDisappear:(BOOL)animated {
    [AKViewDispatcher viewWillDisappear:animated viewController:(UIViewController *)self];
    [self swizzledWillDisappear:animated];
}

- (void)swizzledDidDisappear:(BOOL)animated {
    [AKViewDispatcher viewDidDisappear:animated viewController:(UIViewController *)self];
    [self swizzledDidDisappear:animated];
}



+ (void)viewDidLoadViewController:(__kindof UIViewController *)viewController {
    for (id<AKViewObserver> observer in observersByViewClass[viewController.class]) {
        if (observer && [observer respondsToSelector:@selector(viewDidLoadViewController:)])
            [observer viewDidLoadViewController:viewController];
    }
}

+ (void)viewWillAppear:(BOOL)animated viewController:(__kindof UIViewController *)viewController {
    for (id<AKViewObserver> observer in observersByViewClass[viewController.class]) {
        if (observer && [observer respondsToSelector:@selector(viewWillAppear:viewController:)])
            [observer viewWillAppear:animated viewController:viewController];
    }
}

+ (void)viewDidAppear:(BOOL)animated viewController:(__kindof UIViewController *)viewController {
    for (id<AKViewObserver> observer in observersByViewClass[viewController.class]) {
        if (observer && [observer respondsToSelector:@selector(viewDidAppear:viewController:)])
            [observer viewDidAppear:animated viewController:viewController];
    }
}

+ (void)viewWillDisappear:(BOOL)animated viewController:(__kindof UIViewController *)viewController {
    for (id<AKViewObserver> observer in observersByViewClass[viewController.class]) {
        if (observer && [observer respondsToSelector:@selector(viewWillDisappear:viewController:)])
            [observer viewWillDisappear:animated viewController:viewController];
    }
}

+ (void)viewDidDisappear:(BOOL)animated viewController:(__kindof UIViewController *)viewController {
    for (id<AKViewObserver> observer in observersByViewClass[viewController.class]) {
        if (observer && [observer respondsToSelector:@selector(viewDidDisappear:viewController:)])
            [observer viewDidDisappear:animated viewController:viewController];
    }
}

static NSMutableDictionary <Class, NSPointerArray *> *observersByViewClass;

+ (void)initialize {
    [super initialize];
    observersByViewClass = [NSMutableDictionary new];//[NSPointerArray weakObjectsPointerArray];
}

+ (void)class:(Class)c swizzleSelector:(SEL)originalSelector withSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(c, originalSelector);
    if (originalMethod) {
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
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
}

+ (void)addViewObserver:(id <AKViewObserver>)viewObserver forClasses:(NSArray<Class> *)classes {
    for (Class c in classes) {
        NSPointerArray *viewObservers = observersByViewClass[c];
        if (!viewObservers) {
            viewObservers = [NSPointerArray weakObjectsPointerArray];
            observersByViewClass[(id<NSCopying>)c] = viewObservers;
        }
        
        [viewObservers addPointer:(__bridge void * _Nullable)(viewObserver)];
        
        [self class:c swizzleSelector:@selector(viewDidLoad) withSelector:@selector(swizzledDidLoad)];
        [self class:c swizzleSelector:@selector(viewWillAppear:) withSelector:@selector(swizzledWillAppear:)];
        [self class:c swizzleSelector:@selector(viewDidAppear:) withSelector:@selector(swizzledDidAppear:)];
        [self class:c swizzleSelector:@selector(viewWillDisappear:) withSelector:@selector(swizzledWillDisappear:)];
        [self class:c swizzleSelector:@selector(viewDidDisappear:) withSelector:@selector(swizzledDidDisappear:)];
    }
    
}

+ (void)removeViewObserver:(id <AKViewObserver>)viewObserver fromClasses:(NSArray<Class> *)classes {
    for (Class c in classes) {
        NSPointerArray *viewObservers = observersByViewClass[c];
        if (viewObservers) {
            NSUInteger indx = 0;
            for (; indx < viewObservers.count; indx++) {
                if ([viewObservers pointerAtIndex:indx] == (__bridge void * _Nullable)(viewObserver)) break;
            }
            if (indx < viewObservers.count) [viewObservers removePointerAtIndex:indx];
        }
    }
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
