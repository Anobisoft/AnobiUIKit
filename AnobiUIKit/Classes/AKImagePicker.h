//
//  AKImagePicker.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 12.09.2017.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AKImagePicker;

@interface UIViewController(AKImagePicker)
- (void)showImagePicker:(AKImagePicker *)picker;
- (void)showImagePicker:(AKImagePicker *)picker
             sourceView:(UIView *)sourceView
             sourceRect:(CGRect)sourceRect;

@end

@interface AKImagePicker : NSObject

+ (instancetype)pickerWithCompletion:(void (^)(UIImage *image))completion;
+ (instancetype)pickerWithSourceType:(UIImagePickerControllerSourceType)sourceType completion:(void (^)(UIImage *image))completion;

@end

