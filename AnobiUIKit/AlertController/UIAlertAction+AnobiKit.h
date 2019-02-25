//
//  UIAlertAction+AnobiKit.h
//  AnobiKit
//
//  Created by Stanislav Pletnev on 11/01/2019.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIAlertAction *UIAlertActionMake(NSString * _Nullable title, UIAlertActionStyle style, __nullable dispatch_block_t handler);
UIAlertAction *UIAlertActionDefaultStyleMake(NSString * _Nullable title, __nullable dispatch_block_t handler);

#pragma mark - UIKitLocalized

UIAlertAction *UIKitLocalizedActionMake(NSString *localizationKey, UIAlertActionStyle style, __nullable dispatch_block_t handler);
UIAlertAction *UIKitLocalizedActionDefaultStyleMake(NSString *localizationKey, __nullable dispatch_block_t handler);

UIAlertAction *UIAlertOKAction(__nullable dispatch_block_t handler);
UIAlertAction *UIAlertCancelAction(__nullable dispatch_block_t handler);
UIAlertAction *UIAlertRedoAction(dispatch_block_t handler);

#pragma mark - 

@interface UIAlertAction (AnobiKit)

@property (nonatomic, nullable) UIImage *image;

@end

NS_ASSUME_NONNULL_END
