//
//  AKImagePicker.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 12.09.2017.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

typedef enum : NSUInteger {
    AKImagePickerSourceOptionAuto = 0,
    AKImagePickerSourceOptionPhotoLibrary = 1 << UIImagePickerControllerSourceTypePhotoLibrary,
    AKImagePickerSourceOptionCamera = 1 << UIImagePickerControllerSourceTypeCamera,
    AKImagePickerSourceOptionSavedPhotosAlbum = 1 << UIImagePickerControllerSourceTypeSavedPhotosAlbum,
} AKImagePickerSourceOption;

static NSInteger const AKImagePickerSupportedImageSourcesCount = 3;
static NSInteger const AKImagePickerSupportedImageSources[] = {
    UIImagePickerControllerSourceTypePhotoLibrary,
    UIImagePickerControllerSourceTypeCamera,
    UIImagePickerControllerSourceTypeSavedPhotosAlbum,
};

NS_ASSUME_NONNULL_BEGIN

typedef void(^AKImagePickerCompletionBlock)(UIImage * _Nullable image);

@class AKImagePicker;

@protocol AKImagePickerDelegate <NSObject>
@required
- (UIAlertAction *)alertActionForImagePicker:(AKImagePicker *)imagePicker
                                  sourceType:(UIImagePickerControllerSourceType)sourceType
                                 withHandler:(void (^)(UIAlertAction *action))handler;

@end

@interface AKImagePicker : NSObject

+ (instancetype)pickerWithCompletion:(AKImagePickerCompletionBlock)completion;
+ (instancetype)pickerWithSourceType:(UIImagePickerControllerSourceType)sourceType completion:(AKImagePickerCompletionBlock)completion;
+ (instancetype)pickerWithSourceOptions:(AKImagePickerSourceOption)options completion:(AKImagePickerCompletionBlock)completion;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, nullable, weak) id<AKImagePickerDelegate> delegate;

@property (nonatomic) BOOL allowsEditing;

@property (nonatomic) UIImagePickerControllerCameraCaptureMode cameraCaptureMode;
@property (nonatomic) UIImagePickerControllerCameraDevice cameraDevice;
@property (nonatomic) UIImagePickerControllerCameraFlashMode   cameraFlashMode;

@property (nonatomic, nullable) NSString *alertTitle;
@property (nonatomic, nullable) NSString *alertMessage;
@property (nonatomic) UIAlertControllerStyle alertPreferredStyle;
@property (nonatomic) UIPopoverArrowDirection permittedArrowDirections;

@end


@interface UIViewController(AKImagePicker)

- (void)showImagePicker:(nonnull AKImagePicker *)picker;

- (void)showImagePicker:(nonnull AKImagePicker *)picker
             sourceView:(nullable UIView *)sourceView;

- (void)showImagePicker:(nonnull AKImagePicker *)picker
             sourceView:(nullable UIView *)sourceView
             sourceRect:(CGRect)sourceRect;

@end

NS_ASSUME_NONNULL_END
