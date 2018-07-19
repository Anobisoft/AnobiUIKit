//
//  UIViewController+AK.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 16.02.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (AK)

+ (UIImage *)imageNamed:(NSString *)name;
- (UIImage *)imageNamed:(NSString *)name;
+ (NSString *)localized:(NSString *)key;
- (NSString *)localized:(NSString *)key;

@end

UIAlertAction *UILocalizedActionMake(NSString *localizationKey, UIAlertActionStyle style, dispatch_block_t handler);
UIAlertAction *UILocalizedActionDefaultStyleMake(NSString *localizationKey, dispatch_block_t handler);

UIAlertAction *UIAlertActionMake(NSString *title, UIAlertActionStyle style, __nullable dispatch_block_t handler);
UIAlertAction *UIAlertActionDefaultStyleMake(NSString *title, __nullable dispatch_block_t handler);
UIAlertAction *UIAlertCancelAction(__nullable dispatch_block_t handler);
UIAlertAction *UIAlertRedoAction(dispatch_block_t handler);

@protocol UIAlertConfigurator <NSObject>
@optional
- (UIAlertControllerStyle)alertControllerPreferredStyle;
- (UIView *)alertControllerPresentationSourceView;
- (CGRect)alertControllerPresentationSourceRect;
- (UIPopoverArrowDirection)alertControllerPresentationPermittedArrowDirections;
@end

@interface UIViewController (UIAlert) <UIAlertConfigurator>

- (void)showAlert:(NSString *)title
        okHandler:(__nullable dispatch_block_t)okHandler;
- (void)showAlert:(NSString *)title message:(NSString  * _Nullable)message
        okHandler:(__nullable dispatch_block_t)okHandler;


- (void)showAlert:(NSString *)title
             redo:(dispatch_block_t)redo cancel:(__nullable dispatch_block_t)cancel;
- (void)showAlert:(NSString *)title message:(NSString  * _Nullable)message
             redo:(dispatch_block_t)redo cancel:(__nullable dispatch_block_t)cancel;


- (void)showAlert:(NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions;
- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions;
- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel;
- (void)showAlert:(NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel;


- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions
     configurator:(id<UIAlertConfigurator>)configurator;
- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel
     configurator:(id<UIAlertConfigurator>)configurator;

@end

NS_ASSUME_NONNULL_END
