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

static NSMutableDictionary<NSString *, NSHashTable *> *observersPoolByViewClass;

+ (void)load {
    observersPoolByViewClass = [NSMutableDictionary new];
}


#pragma mark - instantiation

+ (instancetype)observerForClass:(Class)c {
    id instance = [self new];
    [self addViewObserver:instance forClass:c];
    return instance;
}

+ (instancetype)observerForClasses:(NSArray<Class> *)classes {
    id instance = [self new];
    [self addViewObserver:instance forClasses:classes];
    return instance;
}


#pragma mark - observers collecting

+ (void)addViewObserver:(id<AKViewObserver>)viewObserver forClass:(Class)c {
    NSString *className;
    if ([c isKindOfClass:NSString.class]) {
        className = (NSString *)c;
        c = NSClassFromString(className);
    } else {
        className = NSStringFromClass(c);
    }
    
    NSHashTable *viewObserversPool = observersPoolByViewClass[className];
    if (!viewObserversPool) {
        viewObserversPool = [NSHashTable weakObjectsHashTable];
        observersPoolByViewClass[className] = viewObserversPool;
    } else if ([viewObserversPool containsObject:viewObserver]) {
        return;
    }
    
    [viewObserversPool addObject:viewObserver];
    
    if ([viewObserver respondsToSelector:@selector(viewDidLoadViewController:)]) {
        [self class:c swizzleSelector:@selector(viewDidLoad) withSelector:@selector(swizzledDidLoad)];
    }
    
    if ([viewObserver respondsToSelector:@selector(viewWillAppear:viewController:)]) {
        [self class:c swizzleSelector:@selector(viewWillAppear:) withSelector:@selector(swizzledWillAppear:)];
    }
    
    if ([viewObserver respondsToSelector:@selector(viewDidAppear:viewController:)]) {
        [self class:c swizzleSelector:@selector(viewDidAppear:) withSelector:@selector(swizzledDidAppear:)];
    }
    
    if ([viewObserver respondsToSelector:@selector(viewWillDisappear:viewController:)]) {
        [self class:c swizzleSelector:@selector(viewWillDisappear:) withSelector:@selector(swizzledWillDisappear:)];
    }
    
    if ([viewObserver respondsToSelector:@selector(viewDidDisappear:viewController:)]) {
        [self class:c swizzleSelector:@selector(viewDidDisappear:) withSelector:@selector(swizzledDidDisappear:)];
    }
}

+ (void)addViewObserver:(id<AKViewObserver>)viewObserver forClasses:(NSArray<Class> *)classes {
    for (Class c in classes) {
        [self addViewObserver:viewObserver forClass:c];
    }
}

+ (void)removeViewObserver:(id<AKViewObserver>)viewObserver fromClass:(Class)c {
    NSHashTable *viewObserversPool = observersPoolByViewClass[NSStringFromClass(c)];
    if (viewObserversPool) {
        [viewObserversPool removeObject:viewObserver];
    }
}

+ (void)removeViewObserver:(id<AKViewObserver>)viewObserver fromClasses:(NSArray<Class> *)classes {
    for (Class c in classes) {
        [self removeViewObserver:viewObserver fromClass:c];
    }
}


#pragma mark - swizzling

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

#pragma mark - swizzling implementation

- (void)swizzledDidLoad {
    [AKViewDispatcher viewDidLoadViewController:(__kindof UIViewController *)self];
    [self swizzledDidLoad];
}

- (void)swizzledWillAppear:(BOOL)animated {
    [AKViewDispatcher viewWillAppear:animated viewController:(__kindof UIViewController *)self];
    [self swizzledWillAppear:animated];
}

- (void)swizzledDidAppear:(BOOL)animated {
    [AKViewDispatcher viewDidAppear:animated viewController:(__kindof UIViewController *)self];
    [self swizzledDidAppear:animated];
}

- (void)swizzledWillDisappear:(BOOL)animated {
    [AKViewDispatcher viewWillDisappear:animated viewController:(__kindof UIViewController *)self];
    [self swizzledWillDisappear:animated];
}

- (void)swizzledDidDisappear:(BOOL)animated {
    [AKViewDispatcher viewDidDisappear:animated viewController:(__kindof UIViewController *)self];
    [self swizzledDidDisappear:animated];
}


#pragma mark - observers methods calling

+ (void)viewDidLoadViewController:(__kindof UIViewController *)viewController {
    NSArray<id<AKViewObserver>> *observers = observersPoolByViewClass[NSStringFromClass(viewController.class)].allObjects;
    for (id<AKViewObserver> observer in observers) {
        if (observer && [observer respondsToSelector:@selector(viewDidLoadViewController:)])
            [observer viewDidLoadViewController:viewController];
    }
}

+ (void)viewWillAppear:(BOOL)animated viewController:(__kindof UIViewController *)viewController {
    NSArray<id<AKViewObserver>> *observers = observersPoolByViewClass[NSStringFromClass(viewController.class)].allObjects;
    for (id<AKViewObserver> observer in observers) {
        if (observer && [observer respondsToSelector:@selector(viewWillAppear:viewController:)])
            [observer viewWillAppear:animated viewController:viewController];
    }
}

+ (void)viewDidAppear:(BOOL)animated viewController:(__kindof UIViewController *)viewController {
    NSArray<id<AKViewObserver>> *observers = observersPoolByViewClass[NSStringFromClass(viewController.class)].allObjects;
    for (id<AKViewObserver> observer in observers) {
        if (observer && [observer respondsToSelector:@selector(viewDidAppear:viewController:)])
            [observer viewDidAppear:animated viewController:viewController];
    }
}

+ (void)viewWillDisappear:(BOOL)animated viewController:(__kindof UIViewController *)viewController {
    NSArray<id<AKViewObserver>> *observers = observersPoolByViewClass[NSStringFromClass(viewController.class)].allObjects;
    for (id<AKViewObserver> observer in observers) {
        if (observer && [observer respondsToSelector:@selector(viewWillDisappear:viewController:)])
            [observer viewWillDisappear:animated viewController:viewController];
    }
}

+ (void)viewDidDisappear:(BOOL)animated viewController:(__kindof UIViewController *)viewController {
    NSArray<id<AKViewObserver>> *observers = observersPoolByViewClass[NSStringFromClass(viewController.class)].allObjects;
    for (id<AKViewObserver> observer in observers) {
        if (observer && [observer respondsToSelector:@selector(viewDidDisappear:viewController:)])
            [observer viewDidDisappear:animated viewController:viewController];
    }
}

+ (__kindof UIViewController *)visibleViewController {
    return [self visibleViewControllerFrom:UIApplication.sharedApplication.keyWindow.rootViewController];
}

+ (__kindof UIViewController *)visibleViewControllerFrom:(__kindof UIViewController *)vc {
    if ([vc isKindOfClass:UINavigationController.class]) {
        __kindof UINavigationController *nc = vc;
        return [self visibleViewControllerFrom:nc.visibleViewController];
    } else if ([vc isKindOfClass:UITabBarController.class]) {
        __kindof UITabBarController *tbc = vc;
        return [self visibleViewControllerFrom:tbc.selectedViewController];
    } else if (vc.presentedViewController) {
        return [self visibleViewControllerFrom:vc.presentedViewController];
    } else if (vc.childViewControllers.count) {
        return [self visibleViewControllerFrom:vc.childViewControllers.lastObject];
    } else {
        return vc;
    }
}

@end
