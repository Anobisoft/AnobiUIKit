//
//  UIAlertAction+AnobiKit.m
//  AnobiKit
//
//  Created by Stanislav Pletnev on 11/01/2019.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

#import "UIAlertAction+AnobiKit.h"
#import <AnobiKit/AKFoundation.h>

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

#pragma mark - UIKitLocalized

UIAlertAction *UIKitLocalizedActionMake(NSString *localizationKey, UIAlertActionStyle style, dispatch_block_t handler) {
    return UIAlertActionMake(UIKitLocalizedString(localizationKey), style, handler);
}

UIAlertAction *UIKitLocalizedActionDefaultStyleMake(NSString *localizationKey, dispatch_block_t handler) {
    return UIKitLocalizedActionMake(localizationKey, UIAlertActionStyleDefault, handler);
}


UIAlertAction *UIAlertCancelAction(dispatch_block_t handler) {
    return UIKitLocalizedActionMake(@"Cancel", UIAlertActionStyleCancel, handler);
}

UIAlertAction *UIAlertRedoAction(dispatch_block_t handler) {
    return UIKitLocalizedActionDefaultStyleMake(@"Redo", handler);
}

UIAlertAction *UIAlertOKAction(dispatch_block_t handler) {
    return UIKitLocalizedActionDefaultStyleMake(@"OK", handler);
}

#pragma mark - 

@implementation UIAlertAction (AnobiKit)

@dynamic image;

@end
