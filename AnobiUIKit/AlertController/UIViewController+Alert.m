//
//  UIViewController+Alert.m
//  AnobiKit
//
//  Created by Stanislav Pletnev on 11/01/2019.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

#import "UIViewController+Alert.h"
#import "UIAlertAction+AnobiKit.h"

@implementation UIViewController (Alert)

- (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString * _Nullable)message
                              actions:(NSArray<UIAlertAction *> *)actions
                         configurator:(id<UIAlertConfigurator> _Nullable)configurator {
    
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
    
    return alert;
}

- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions
     configurator:(id<UIAlertConfigurator> _Nullable)configurator {
    
    UIAlertController *alert = [self alertWithTitle:title message:message actions:actions configurator:configurator];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showAlert:(NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions
     configurator:(id<UIAlertConfigurator> _Nullable)configurator {
    
    [self showAlert:title message:nil actions:actions configurator:configurator];
}

- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel
     configurator:(id<UIAlertConfigurator> _Nullable)configurator {
    
    [self showAlert:title message:message
            actions:[actions arrayByAddingObject:UIAlertCancelAction(cancel)]
       configurator:configurator];
}

- (void)showAlert:(NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel
     configurator:(id<UIAlertConfigurator> _Nullable)configurator {
    
    [self showAlert:title message:nil actions:actions cancel:cancel configurator:configurator];
}

#pragma mark - self configuration

- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions {
    
    [self showAlert:title message:message actions:actions configurator:nil];
}

- (void)showAlert:(NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions {
    
    [self showAlert:title message:nil actions:actions configurator:nil];
}

- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel {
    
    [self showAlert:title message:message actions:actions cancel:cancel configurator:nil];
}

- (void)showAlert:(NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel {
    
    [self showAlert:title message:nil actions:actions cancel:cancel configurator:nil];
}

#pragma mark - OK

- (void)showNotice:(NSString *)title
        completion:(__nullable dispatch_block_t)completion {
    
    [self showNotice:title message:nil completion:completion];
}
- (void)showNotice:(NSString *)title message:(NSString  * _Nullable)message
        completion:(__nullable dispatch_block_t)completion {
    
    [self showAlert:title message:message
            actions:@[UIAlertOKAction(completion)]];
}

#pragma mark - Dialog

- (void)showDialog:(NSString *)title message:(NSString  * _Nullable)message
                ok:(dispatch_block_t)ok cancel:(__nullable dispatch_block_t)cancel {
    
    [self showAlert:title message:message actions:@[UIAlertOKAction(ok), UIAlertCancelAction(cancel)]];
}

- (void)showDialog:(NSString *)title
                ok:(dispatch_block_t)ok cancel:(__nullable dispatch_block_t)cancel {
    
    [self showDialog:title message:nil ok:ok cancel:cancel];
}

- (void)showDialog:(NSString *)title message:(NSString  * _Nullable)message
            action:(UIAlertAction *)action cancel:(__nullable dispatch_block_t)cancel {
    
    [self showAlert:title message:message actions:@[action] cancel:cancel];
}

- (void)showDialog:(NSString *)title
            action:(UIAlertAction *)action cancel:(__nullable dispatch_block_t)cancel {
    
    [self showDialog:title message:nil action:action cancel:cancel];
}

#pragma mark - Redo

- (void)showDialog:(NSString *)title message:(NSString  * _Nullable)message
              redo:(dispatch_block_t)redo cancel:(__nullable dispatch_block_t)cancel {
    
    [self showAlert:title message:message actions:@[UIAlertRedoAction(redo)] cancel:cancel];
}

- (void)showDialog:(NSString *)title
              redo:(dispatch_block_t)redo cancel:(__nullable dispatch_block_t)cancel {
    
    [self showDialog:title message:nil redo:redo cancel:cancel];
}

@end
