//
//  AKViewDispatcher.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 2017-03-04
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AnobiKit/AKTypes.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AKViewObserver <NSObject>
@optional
- (void)viewDidLoadViewController:(UIViewController *)viewController;
- (void)viewWillAppear:(BOOL)animated    viewController:(UIViewController *)viewController;
- (void)viewDidAppear:(BOOL)animated     viewController:(UIViewController *)viewController;
- (void)viewWillDisappear:(BOOL)animated viewController:(UIViewController *)viewController;
- (void)viewDidDisappear:(BOOL)animated  viewController:(UIViewController *)viewController;

- (void)viewDidLoadViewController:(UIViewController *)viewController originInvocation:(dispatch_block_t)originInvocation;
- (void)viewWillAppear:(BOOL)animated    viewController:(UIViewController *)viewController originInvocation:(dispatch_block_t)originInvocation;
- (void)viewDidAppear:(BOOL)animated     viewController:(UIViewController *)viewController originInvocation:(dispatch_block_t)originInvocation;
- (void)viewWillDisappear:(BOOL)animated viewController:(UIViewController *)viewController originInvocation:(dispatch_block_t)originInvocation;
- (void)viewDidDisappear:(BOOL)animated  viewController:(UIViewController *)viewController originInvocation:(dispatch_block_t)originInvocation;

@end

@interface AKViewDispatcher : NSObject <Abstract>

+ (UIViewController *)visibleViewController;
+ (UIViewController *)visibleViewControllerFrom:(UIViewController *)vc;

+ (void)addViewObserver:(id <AKViewObserver>)viewObserver forClasses:(NSArray<Class> *)classes;
+ (void)removeViewObserver:(id <AKViewObserver>)viewObserver fromClasses:(NSArray<Class> *)classes;
+ (void)cleanupObserversPool;

@end

NS_ASSUME_NONNULL_END
