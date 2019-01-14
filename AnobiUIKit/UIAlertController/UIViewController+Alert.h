//
//  UIViewController+Alert.h
//  AnobiKit
//
//  Created by Stanislav Pletnev on 11/01/2019.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertConfigurator.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Alert) <UIAlertConfigurator>

- (UIAlertController *)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message
                              actions:(NSArray<UIAlertAction *> *)actions
                         configurator:(nullable id<UIAlertConfigurator>)configurator;

- (void)showAlert:(nullable NSString *)title message:(nullable NSString *)message
          actions:(NSArray<UIAlertAction *> *)actions
     configurator:(nullable id<UIAlertConfigurator>)configurator;

- (void)showAlert:(nullable NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions
     configurator:(nullable id<UIAlertConfigurator>)configurator;

- (void)showAlert:(nullable NSString *)title message:(nullable NSString *)message
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel
     configurator:(nullable id<UIAlertConfigurator>)configurator;

- (void)showAlert:(nullable NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel
     configurator:(nullable id<UIAlertConfigurator>)configurator;

#pragma mark - self configuration

- (void)showAlert:(nullable NSString *)title message:(nullable NSString *)message
          actions:(NSArray<UIAlertAction *> *)actions;

- (void)showAlert:(nullable NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions;

- (void)showAlert:(nullable NSString *)title message:(nullable NSString *)message
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel;

- (void)showAlert:(nullable NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel;

#pragma mark - OK

- (void)showNotice:(nullable NSString *)title
        completion:(__nullable dispatch_block_t)completion;

- (void)showNotice:(nullable NSString *)title message:(nullable NSString *)message
        completion:(__nullable dispatch_block_t)completion;

#pragma mark - Dialog

- (void)showDialog:(nullable NSString *)title message:(nullable NSString *)message
                ok:(dispatch_block_t)ok cancel:(__nullable dispatch_block_t)cancel;

- (void)showDialog:(nullable NSString *)title
                ok:(dispatch_block_t)ok cancel:(__nullable dispatch_block_t)cancel;

- (void)showDialog:(nullable NSString *)title message:(nullable NSString *)message
            action:(UIAlertAction *)action cancel:(__nullable dispatch_block_t)cancel;

- (void)showDialog:(nullable NSString *)title
            action:(UIAlertAction *)action cancel:(__nullable dispatch_block_t)cancel;

#pragma mark - Redo

- (void)showDialog:(nullable NSString *)title message:(nullable NSString *)message
              redo:(dispatch_block_t)redo cancel:(__nullable dispatch_block_t)cancel;

- (void)showDialog:(nullable NSString *)title
              redo:(dispatch_block_t)redo cancel:(__nullable dispatch_block_t)cancel;

@end

NS_ASSUME_NONNULL_END
