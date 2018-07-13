//
//  UIViewController+AK.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 16.02.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import "UIViewController+AK.h"
#import "NSBundle+UI.h"

@implementation UIViewController (AK)

+ (UIImage *)imageNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[NSBundle bundleForClass:self] compatibleWithTraitCollection:nil];
}

- (UIImage *)imageNamed:(NSString *)name {
    return [self.class imageNamed:name];
}

+ (NSString *)localized:(NSString *)key {
    return [[NSBundle bundleForClass:self] localizedStringForKey:key];
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

#pragma mark -
#pragma mark - OK

- (void)showAlert:(NSString *)title okHandler:(dispatch_block_t)okHandler {
    [self showAlert:title message:nil okHandler:okHandler];
}

- (void)showAlert:(NSString *)title message:(NSString *)message okHandler:(dispatch_block_t)okHandler {
    [self showAlert:title message:message
            actions:@[UIAlertActionDefaultStyleMake(UIBundleLocalizedString(@"OK"), okHandler)]];
}



#pragma mark -
#pragma mark - Redo

- (void)showAlert:(NSString *)title
             redo:(dispatch_block_t)redo cancel:(dispatch_block_t)cancel {
    [self showAlert:title message:nil redo:redo cancel:cancel];
}

- (void)showAlert:(NSString *)title message:(NSString *)message
             redo:(dispatch_block_t)redo cancel:(dispatch_block_t)cancel {
    [self showAlert:title message:message actions:@[UIAlertRedoAction(redo), UIAlertCancelAction(cancel)]];
}



#pragma mark -
#pragma mark - Universal

- (void)showAlert:(NSString *)title message:(NSString *)message
          actions:(NSArray<UIAlertAction *> *)actions {
    
    [self showAlert:title message:message
            actions:actions
       configurator:self];
}

- (void)showAlert:(NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions {
    
    [self showAlert:title message:nil
            actions:actions];
}

- (void)showAlert:(NSString *)title message:(NSString *)message
          actions:(NSArray<UIAlertAction *> *)actions cancel:(dispatch_block_t)cancel {
    
    [self showAlert:title message:message
            actions:[actions arrayByAddingObject:UIAlertCancelAction(cancel)]];
}

- (void)showAlert:(NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions cancel:(dispatch_block_t)cancel {
    
    [self showAlert:title message:nil
            actions:actions cancel:cancel];
}



#pragma mark -
#pragma mark - UIAlertConfigurator

- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions
     configurator:(id<UIAlertConfigurator>)configurator {
    
    if (!configurator) {
        configurator = self;
    }
    
    BOOL iPadDevice = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    UIAlertControllerStyle preferredStyle = iPadDevice ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet;
    
    if ([configurator respondsToSelector:@selector(alertControllerPreferredStyle)]) {
        preferredStyle = [configurator alertControllerPreferredStyle];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:preferredStyle];
    for (UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    
    if (iPadDevice && preferredStyle == UIAlertControllerStyleActionSheet) {
        UIView *sourceView = nil;
        if ([configurator respondsToSelector:@selector(alertControllerPresentationSourceView)]) {
            sourceView = [configurator alertControllerPresentationSourceView];
        }
        if (!sourceView) {
            sourceView = self.view;
        }
        
        CGRect sourceRect = CGRectNull;
        if ([configurator respondsToSelector:@selector(alertControllerPresentationSourceRect)]) {
            sourceRect = [configurator alertControllerPresentationSourceRect];
        }
        if (CGRectIsNull(sourceRect)) {
            CGPoint center = sourceView.center;
            sourceRect = CGRectMake(center.x, center.y, 1, 1);
        }
        
        UIPopoverArrowDirection arrowDirections = UIPopoverArrowDirectionAny;
        if ([configurator respondsToSelector:@selector(alertControllerPresentationPermittedArrowDirections)]) {
            arrowDirections = [configurator alertControllerPresentationPermittedArrowDirections];
        }
        
        alert.popoverPresentationController.sourceView = sourceView;
        alert.popoverPresentationController.sourceRect = sourceRect;
        alert.popoverPresentationController.permittedArrowDirections = arrowDirections;
    }
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel
     configurator:(id<UIAlertConfigurator>)configurator {
    
    [self showAlert:title message:message
            actions:[actions arrayByAddingObject:UIAlertCancelAction(cancel)]
       configurator:configurator];
}

@end
