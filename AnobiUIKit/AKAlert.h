//
//  AKAlert.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 13/08/2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UIAlertConfigurator <NSObject>
@optional
- (UIAlertControllerStyle)alertControllerPreferredStyle;
- (UIView *)alertControllerPresentationSourceView;
- (CGRect)alertControllerPresentationSourceRect;
- (UIPopoverArrowDirection)alertControllerPresentationPermittedArrowDirections;
@end

#pragma mark -

UIAlertAction *UILocalizedActionMake(NSString *localizationKey, UIAlertActionStyle style, dispatch_block_t handler);
UIAlertAction *UILocalizedActionDefaultStyleMake(NSString *localizationKey, dispatch_block_t handler);

UIAlertAction *UIAlertOKAction(dispatch_block_t handler);
UIAlertAction *UIAlertCancelAction(__nullable dispatch_block_t handler);
UIAlertAction *UIAlertRedoAction(dispatch_block_t handler);

UIAlertAction *UIAlertActionMake(NSString *title, UIAlertActionStyle style, __nullable dispatch_block_t handler);
UIAlertAction *UIAlertActionDefaultStyleMake(NSString *title, __nullable dispatch_block_t handler);

#pragma mark -

@interface UIViewController (UIAlert) <UIAlertConfigurator>

- (void)showNotice:(NSString *)title
        completion:(__nullable dispatch_block_t)completion;
- (void)showNotice:(NSString *)title message:(NSString  * _Nullable)message
        completion:(__nullable dispatch_block_t)completion;

- (void)showDialog:(NSString *)title
                ok:(dispatch_block_t)ok
            cancel:(__nullable dispatch_block_t)cancel;
- (void)showDialog:(NSString *)title message:(NSString  * _Nullable)message
                ok:(dispatch_block_t)ok
            cancel:(__nullable dispatch_block_t)cancel;

- (void)showDialog:(NSString *)title
            action:(UIAlertAction *)action
            cancel:(__nullable dispatch_block_t)cancel;
- (void)showDialog:(NSString *)title message:(NSString  * _Nullable)message
            action:(UIAlertAction *)action
            cancel:(__nullable dispatch_block_t)cancel;

- (void)showDialog:(NSString *)title
              redo:(dispatch_block_t)redo cancel:(__nullable dispatch_block_t)cancel;
- (void)showDialog:(NSString *)title message:(NSString  * _Nullable)message
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
     configurator:(id<UIAlertConfigurator> _Nullable)configurator;
- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel
     configurator:(id<UIAlertConfigurator> _Nullable)configurator;

@end

NS_ASSUME_NONNULL_END
