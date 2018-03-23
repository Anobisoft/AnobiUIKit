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

@end

UIAlertAction *UIAlertActionMake(NSString *title, UIAlertActionStyle style, __nullable dispatch_block_t handler);
UIAlertAction *UIAlertActionDefaultStyleMake(NSString *title, dispatch_block_t handler);
UIAlertAction *UIAlertCancelAction(__nullable dispatch_block_t handler);
UIAlertAction *UIAlertRedoAction(dispatch_block_t handler);

@interface UIViewController (UIAlert)

- (void)showAlert:(NSString *)title
        okHandler:(dispatch_block_t)okHandler;
- (void)showAlert:(NSString *)title message:(NSString  * _Nullable)message
        okHandler:(dispatch_block_t)okHandler;

- (void)showAlert:(NSString *)title
             redo:(dispatch_block_t)redo cancel:(dispatch_block_t)cancel;
- (void)showAlert:(NSString *)title message:(NSString  * _Nullable)message
             redo:(dispatch_block_t)redo cancel:(dispatch_block_t)cancel;

- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions;
- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions cancel:(dispatch_block_t)cancel;

@end

NS_ASSUME_NONNULL_END
