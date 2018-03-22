//
//  AKViewDispatcher.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 2017-03-04
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKViewDispatcher.h"
#import <objc/runtime.h>

@implementation AKViewDispatcher

- (void)swizzledDidLoad {
    [AKViewDispatcher viewDidLoadViewController:(UIViewController *)self originInvocation:^{
        [self swizzledDidLoad];
    }];
}

- (void)swizzledWillAppear:(BOOL)animated {
    [AKViewDispatcher viewWillAppear:animated viewController:(UIViewController *)self originInvocation:^{
        [self swizzledWillAppear:animated];
    }];
}

- (void)swizzledDidAppear:(BOOL)animated {
    [AKViewDispatcher viewDidAppear:animated viewController:(UIViewController *)self originInvocation:^{
        [self swizzledDidAppear:animated];
    }];
}

- (void)swizzledWillDisappear:(BOOL)animated {
    [AKViewDispatcher viewWillDisappear:animated viewController:(UIViewController *)self originInvocation:^{
        [self swizzledWillDisappear:animated];
    }];
}

- (void)swizzledDidDisappear:(BOOL)animated {
    [AKViewDispatcher viewDidDisappear:animated viewController:(UIViewController *)self originInvocation:^{
        [self swizzledDidDisappear:animated];
    }];    
}



+ (void)viewDidLoadViewController:(__kindof UIViewController *)viewController originInvocation:(dispatch_block_t)originInvocation {
    for (id<AKViewObserver> observer in observersPoolByViewClass[viewController.class]) {
        if (observer) {
            if ([observer respondsToSelector:@selector(viewDidLoadViewController:)])
                [observer viewDidLoadViewController:viewController];
            if ([observer respondsToSelector:@selector(viewDidLoadViewController:originInvocation:)])
                [observer viewDidLoadViewController:viewController originInvocation:originInvocation];
        }
    }
}

+ (void)viewWillAppear:(BOOL)animated viewController:(__kindof UIViewController *)viewController originInvocation:(dispatch_block_t)originInvocation {
    for (id<AKViewObserver> observer in observersPoolByViewClass[viewController.class]) {
        if (observer) {
            if ([observer respondsToSelector:@selector(viewWillAppear:viewController:)])
                [observer viewWillAppear:animated viewController:viewController];
            if ([observer respondsToSelector:@selector(viewWillAppear:viewController:originInvocation:)])
                [observer viewWillAppear:animated viewController:viewController originInvocation:originInvocation];
        }

    }
}

+ (void)viewDidAppear:(BOOL)animated viewController:(__kindof UIViewController *)viewController originInvocation:(dispatch_block_t)originInvocation {
    for (id<AKViewObserver> observer in observersPoolByViewClass[viewController.class]) {
        if (observer) {
            if ([observer respondsToSelector:@selector(viewDidAppear:viewController:)])
                [observer viewDidAppear:animated viewController:viewController];
            if ([observer respondsToSelector:@selector(viewDidAppear:viewController:originInvocation:)])
                [observer viewDidAppear:animated viewController:viewController originInvocation:originInvocation];
        }
    }
}

+ (void)viewWillDisappear:(BOOL)animated viewController:(__kindof UIViewController *)viewController originInvocation:(dispatch_block_t)originInvocation {
    for (id<AKViewObserver> observer in observersPoolByViewClass[viewController.class]) {
        if (observer) {
            if ([observer respondsToSelector:@selector(viewWillDisappear:viewController:)])
                [observer viewWillDisappear:animated viewController:viewController];
            if ([observer respondsToSelector:@selector(viewWillDisappear:viewController:originInvocation:)])
                [observer viewWillDisappear:animated viewController:viewController originInvocation:originInvocation];
        }
    }
}

+ (void)viewDidDisappear:(BOOL)animated viewController:(__kindof UIViewController *)viewController originInvocation:(dispatch_block_t)originInvocation {
    for (id<AKViewObserver> observer in observersPoolByViewClass[viewController.class]) {
        if (observer) {
            if ([observer respondsToSelector:@selector(viewDidDisappear:viewController:)])
                [observer viewDidDisappear:animated viewController:viewController];
            if ([observer respondsToSelector:@selector(viewDidDisappear:viewController:originInvocation:)])
                [observer viewDidDisappear:animated viewController:viewController originInvocation:originInvocation];
        }
    }
}

static NSMutableDictionary <Class, NSPointerArray *> *observersPoolByViewClass;

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
    if (!viewObserver) return ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        observersPoolByViewClass = [NSMutableDictionary new];
    });    
    for (Class c in classes) {
        NSPointerArray *viewObserversPool = observersPoolByViewClass[c];
        if (!viewObserversPool) {
            viewObserversPool = [NSPointerArray weakObjectsPointerArray];
            observersPoolByViewClass[(id<NSCopying>)c] = viewObserversPool;
        }
        
        [viewObserversPool addPointer:(__bridge void * _Nullable)(viewObserver)];
        
        if ([viewObserver respondsToSelector:@selector(viewDidLoadViewController:)] ||
            [viewObserver respondsToSelector:@selector(viewDidLoadViewController:originInvocation:)]) {
            [self class:c swizzleSelector:@selector(viewDidLoad) withSelector:@selector(swizzledDidLoad)];
        }
            
        if ([viewObserver respondsToSelector:@selector(viewWillAppear:viewController:)] ||
            [viewObserver respondsToSelector:@selector(viewWillAppear:viewController:originInvocation:)]) {
            [self class:c swizzleSelector:@selector(viewWillAppear:) withSelector:@selector(swizzledWillAppear:)];
        }
        
        if ([viewObserver respondsToSelector:@selector(viewDidAppear:viewController:)] ||
            [viewObserver respondsToSelector:@selector(viewDidAppear:viewController:originInvocation:)]) {
            [self class:c swizzleSelector:@selector(viewDidAppear:) withSelector:@selector(swizzledDidAppear:)];
        }
        
        if ([viewObserver respondsToSelector:@selector(viewWillDisappear:viewController:)] ||
            [viewObserver respondsToSelector:@selector(viewWillDisappear:viewController:originInvocation:)]) {
            [self class:c swizzleSelector:@selector(viewWillDisappear:) withSelector:@selector(swizzledWillDisappear:)];
        }
        
        if ([viewObserver respondsToSelector:@selector(viewDidDisappear:viewController:)] ||
            [viewObserver respondsToSelector:@selector(viewDidDisappear:viewController:originInvocation:)]) {
            [self class:c swizzleSelector:@selector(viewDidDisappear:) withSelector:@selector(swizzledDidDisappear:)];
        }
    }    
}

+ (void)removeViewObserver:(id <AKViewObserver>)viewObserver fromClasses:(NSArray<Class> *)classes {
    for (Class c in classes) {
        NSPointerArray *viewObserversPool = observersPoolByViewClass[c];
        if (viewObserversPool) {
            NSUInteger indx = 0;
            for (; indx < viewObserversPool.count; indx++) {
                if ([viewObserversPool pointerAtIndex:indx] == (__bridge void * _Nullable)(viewObserver)) break;
            }
            if (indx < viewObserversPool.count) {
                [viewObserversPool removePointerAtIndex:indx];
            }
        }
    }
}

+ (void)cleanupObserversPool {
    for (NSPointerArray *viewObserversPool in observersPoolByViewClass.allValues) {
        [viewObserversPool compact];
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
    } else if (vc.presentedViewController) {
        return [self visibleViewControllerFrom:vc.presentedViewController];
    } else if (vc.childViewControllers.count) {
        return [self visibleViewControllerFrom:vc.childViewControllers.lastObject];
    } else {
        return vc;
    }
}

@end
