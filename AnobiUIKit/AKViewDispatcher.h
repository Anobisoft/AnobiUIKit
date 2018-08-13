//
//  AKViewDispatcher.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 2017-03-04
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AKViewObserver <NSObject>
@optional
- (void)viewDidLoadViewController:(__kindof UIViewController *)viewController;
- (void)viewWillAppear:(BOOL)animated viewController:(__kindof UIViewController *)viewController;
- (void)viewDidAppear:(BOOL)animated viewController:(__kindof UIViewController *)viewController;
- (void)viewWillDisappear:(BOOL)animated viewController:(__kindof UIViewController *)viewController;
- (void)viewDidDisappear:(BOOL)animated viewController:(__kindof UIViewController *)viewController;

@end

@interface AKViewDispatcher : NSObject <AKViewObserver>

+ (__kindof UIViewController *)visibleViewController;
+ (__kindof UIViewController *)visibleViewControllerFrom:(__kindof UIViewController *)vc;

+ (void)addViewObserver:(id<AKViewObserver>)viewObserver forClass:(Class)c;
+ (void)removeViewObserver:(id<AKViewObserver>)viewObserver fromClass:(Class)c;
+ (void)addViewObserver:(id<AKViewObserver>)viewObserver forClasses:(NSArray<Class> *)classes;
+ (void)removeViewObserver:(id<AKViewObserver>)viewObserver fromClasses:(NSArray<Class> *)classes;

+ (instancetype)observerForClass:(Class)c;
+ (instancetype)observerForClasses:(NSArray<Class> *)classes;

@end
