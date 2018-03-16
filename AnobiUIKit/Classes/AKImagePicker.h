//
//  AKImagePicker.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 12.09.2017.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AKImagePickerSourceOptionAuto = 0,
    AKImagePickerSourceOptionPhotoLibrary = 1 << 0,
    AKImagePickerSourceOptionCamera = 1 << 1,
    AKImagePickerSourceOptionSavedPhotosAlbum = 1 << 2,
} AKImagePickerSourceOption;

@interface AKImagePicker : NSObject

+ (instancetype)pickerWithCompletion:(void (^)(UIImage *image))completion;
+ (instancetype)pickerWithSourceType:(UIImagePickerControllerSourceType)sourceType completion:(void (^)(UIImage *image))completion;
+ (instancetype)pickerWithSourceOptions:(AKImagePickerSourceOption)options completion:(void (^)(UIImage *image))completion;

@property (nonatomic) BOOL allowsEditing;

@property (nonatomic) UIImagePickerControllerCameraCaptureMode cameraCaptureMode;
@property (nonatomic) UIImagePickerControllerCameraDevice cameraDevice;
@property (nonatomic) UIImagePickerControllerCameraFlashMode   cameraFlashMode;

@property (nonatomic) NSString *alertTitle;
@property (nonatomic) NSString *alertMessage;
@property (nonatomic) UIAlertControllerStyle alertPreferredStyle;

@end

@interface UIViewController(AKImagePicker)
- (void)showImagePicker:(AKImagePicker *)picker;
- (void)showImagePicker:(AKImagePicker *)picker
             sourceView:(UIView *)sourceView
             sourceRect:(CGRect)sourceRect;

@end

