//
//  AKAlert.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 13/08/2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import "AKAlert.h"
#import <AnobiKit/AnobiKit.h>

#pragma mark -

UIAlertAction *UILocalizedActionMake(NSString *localizationKey, UIAlertActionStyle style, dispatch_block_t handler) {
    return UIAlertActionMake(UIKitLocalizedString(localizationKey), style, handler);
}

UIAlertAction *UILocalizedActionDefaultStyleMake(NSString *localizationKey, dispatch_block_t handler) {
    return UILocalizedActionMake(localizationKey, UIAlertActionStyleDefault, handler);
}

UIAlertAction *UIAlertActionMake(NSString *title, UIAlertActionStyle style, dispatch_block_t handler) {
    return [UIAlertAction actionWithTitle:AKLocalizedString(title)
                                    style:style
                                  handler:^(UIAlertAction *action) {
                                      if (handler) handler();
                                  }];
}

UIAlertAction *UIAlertActionDefaultStyleMake(NSString *title, dispatch_block_t handler) {
    return UIAlertActionMake(title, UIAlertActionStyleDefault, handler);
}

UIAlertAction *UIAlertCancelAction(dispatch_block_t handler) {
    return UILocalizedActionMake(@"Cancel", UIAlertActionStyleCancel, handler);
}

UIAlertAction *UIAlertRedoAction(dispatch_block_t handler) {
    return UILocalizedActionDefaultStyleMake(@"Redo", handler);
}

UIAlertAction *UIAlertOKAction(dispatch_block_t handler) {
    return UILocalizedActionDefaultStyleMake(@"OK", handler);
}

#pragma mark -

@implementation UIViewController (UIAlert)



#pragma mark -
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

- (void)showDialog:(NSString *)title
                ok:(dispatch_block_t)ok
            cancel:(__nullable dispatch_block_t)cancel {
    [self showDialog:title message:nil ok:ok cancel:cancel];
}

- (void)showDialog:(NSString *)title message:(NSString  * _Nullable)message
                ok:(dispatch_block_t)ok
            cancel:(__nullable dispatch_block_t)cancel {
    [self showAlert:title message:message actions:@[UIAlertOKAction(ok), UIAlertCancelAction(cancel)]];
}

- (void)showDialog:(NSString *)title
            action:(UIAlertAction *)action
            cancel:(__nullable dispatch_block_t)cancel {
    [self showDialog:title message:nil action:action cancel:cancel];
}

- (void)showDialog:(NSString *)title message:(NSString  * _Nullable)message
            action:(UIAlertAction *)action
            cancel:(__nullable dispatch_block_t)cancel {
    [self showAlert:title message:message actions:@[action, UIAlertCancelAction(cancel)]];
}

#pragma mark -
#pragma mark - Redo

- (void)showDialog:(NSString *)title
              redo:(dispatch_block_t)redo cancel:(__nullable dispatch_block_t)cancel {
    [self showDialog:title message:nil redo:redo cancel:cancel];
}

- (void)showDialog:(NSString *)title message:(NSString  * _Nullable)message
              redo:(dispatch_block_t)redo
            cancel:(__nullable dispatch_block_t)cancel {
    [self showAlert:title message:message actions:@[UIAlertRedoAction(redo), UIAlertCancelAction(cancel)]];
}



#pragma mark -
#pragma mark - Universal

- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions {
    
    [self showAlert:title message:message
            actions:actions
       configurator:nil];
}

- (void)showAlert:(NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions {
    
    [self showAlert:title message:nil
            actions:actions];
}

- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel {
    
    [self showAlert:title message:message
            actions:[actions arrayByAddingObject:UIAlertCancelAction(cancel)]];
}

- (void)showAlert:(NSString *)title
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel {
    
    [self showAlert:title message:nil
            actions:actions cancel:cancel];
}



#pragma mark -
#pragma mark - UIAlertConfigurator

- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
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
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showAlert:(NSString *)title message:(NSString * _Nullable)message
          actions:(NSArray<UIAlertAction *> *)actions cancel:(__nullable dispatch_block_t)cancel
     configurator:(id<UIAlertConfigurator> _Nullable)configurator {
    
    [self showAlert:title message:message
            actions:[actions arrayByAddingObject:UIAlertCancelAction(cancel)]
       configurator:configurator];
}

@end
