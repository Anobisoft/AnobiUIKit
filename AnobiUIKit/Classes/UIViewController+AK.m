//
//  UIViewController+AK.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 16.02.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import "UIViewController+AK.h"
#import "NSBundle+AKUI.h"

#define UIBundleLocalizedString(key) [[NSBundle bundleForClass:UIApplication.class] localizedStringForKey:key value:nil table:nil]

@implementation UIViewController (AK)

+ (UIImage *)imageNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[NSBundle bundleForClass:self] compatibleWithTraitCollection:nil];
}

- (UIImage *)imageNamed:(NSString *)name {
    return [self.class imageNamed:name];
}

+ (NSString *)localized:(NSString *)key {
    return [[NSBundle bundleForClass:self] localizedStringForKey:key value:nil table:nil];
}

- (NSString *)localized:(NSString *)key {
    return [self.class localized:key];
}

@end

UIAlertAction *UILocalizedActionMake(NSString *localizationKey, dispatch_block_t handler) {
    return UIAlertActionDefaultStyleMake([[NSBundle UIBundle] localizedStringForKey:localizationKey], handler);
}

UIAlertAction *UIAlertActionMake(NSString *title, UIAlertActionStyle style, dispatch_block_t handler) {
    return [UIAlertAction actionWithTitle:title
                                    style:style
                                  handler:^(UIAlertAction *action) {
                                      if (handler) handler();
                                  }];
}

UIAlertAction *UIAlertActionDefaultStyleMake(NSString *title, dispatch_block_t handler) {
    return UIAlertActionMake(title, UIAlertActionStyleDefault, handler);
}

UIAlertAction *UIAlertCancelAction(dispatch_block_t handler) {
    return UIAlertActionMake(UIBundleLocalizedString(@"Cancel"), UIAlertActionStyleCancel, handler);
}

UIAlertAction *UIAlertRedoAction(dispatch_block_t handler) {
    return UIAlertActionDefaultStyleMake(UIBundleLocalizedString(@"Redo"), handler);
}

@implementation UIViewController (UIAlert)

- (void)showAlert:(NSString *)title okHandler:(dispatch_block_t)okHandler {
    [self showAlert:title message:nil okHandler:okHandler];
}

- (void)showAlert:(NSString *)title message:(NSString *)message okHandler:(dispatch_block_t)okHandler {
    [self showAlert:title message:message
            actions:@[ UIAlertActionMake(UIBundleLocalizedString(@"OK"), UIAlertActionStyleDefault, okHandler) ]];
}

- (void)showAlert:(NSString *)title
             redo:(dispatch_block_t)redo cancel:(dispatch_block_t)cancel {
    [self showAlert:title message:nil redo:redo cancel:cancel];
}

- (void)showAlert:(NSString *)title message:(NSString *)message
             redo:(dispatch_block_t)redo cancel:(dispatch_block_t)cancel {
    [self showAlert:title message:message actions:@[UIAlertRedoAction(redo), UIAlertCancelAction(cancel)]];
}

- (void)showAlert:(NSString *)title message:(NSString *)message
          actions:(NSArray<UIAlertAction *> *)actions {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    for (UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showAlert:(NSString *)title message:(NSString *)message
          actions:(NSArray<UIAlertAction *> *)actions cancel:(dispatch_block_t)cancel {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    for (UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    [alert addAction:UIAlertCancelAction(cancel)];
    [self presentViewController:alert animated:true completion:nil];
}

@end
