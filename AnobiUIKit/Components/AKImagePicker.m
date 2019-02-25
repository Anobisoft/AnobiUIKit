//
//  AKImagePicker.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 12.09.2017.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKImagePicker.h"
#import "AKAlert.h"

@interface AKImagePicker() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertConfigurator>

@property (nonatomic, weak) UIView *sourceView;
@property (nonatomic) CGRect sourceRect;
@property (nonatomic) UIImagePickerController *pickerController;
@property (nonatomic) NSDictionary *sourceLocalizationMap;
@property (nonatomic) AKImagePickerCompletionBlock completionBlock;

- (void)showOnViewController:(__kindof UIViewController *)viewController;

@end

@implementation AKImagePicker {
    BOOL availableIndexes[AKImagePickerSupportedImageSourcesCount];
    UIImagePickerControllerSourceType defaultSourceType;
    NSInteger availableCount;
}

+ (instancetype)pickerWithSourceType:(UIImagePickerControllerSourceType)sourceType completion:(AKImagePickerCompletionBlock)completion {
    return [self pickerWithSourceOptions:1 << sourceType completion:completion];
}

+ (instancetype)pickerWithSourceOptions:(AKImagePickerSourceOption)options completion:(AKImagePickerCompletionBlock)completion {
    return [[self alloc] initWithSourceOptions:options completion:completion];
}

+ (instancetype)pickerWithCompletion:(AKImagePickerCompletionBlock)completion {
    return [[self alloc] initWithCompletion:completion];
}

BOOL SourceAvailable(UIImagePickerControllerSourceType sourceType) {
    return [UIImagePickerController isSourceTypeAvailable:sourceType];
}

- (instancetype)initWithCompletion:(void (^)(UIImage *image))completion {
    return [self initWithSourceOptions:AKImagePickerSourceOptionAuto completion:completion];
}

- (instancetype)initWithSourceOptions:(AKImagePickerSourceOption)options completion:(void (^)(UIImage *image))completion {
    if (self = [super init]) {
        self.alertPreferredStyle = UIAlertControllerStyleActionSheet;
        self.completionBlock = completion;
        if (options == AKImagePickerSourceOptionAuto) {
            options = AKImagePickerSourceOptionPhotoLibrary + AKImagePickerSourceOptionCamera + AKImagePickerSourceOptionSavedPhotosAlbum;
        }
        availableCount = 0;
        for (int sourceTypeIndex = 0; sourceTypeIndex < AKImagePickerSupportedImageSourcesCount; sourceTypeIndex++) {
            UIImagePickerControllerSourceType sourceType = AKImagePickerSupportedImageSources[sourceTypeIndex];
            if (options & (1 << sourceType)) {
                BOOL available = SourceAvailable(sourceType);
                availableIndexes[sourceTypeIndex] = available;
                if (available) {
                    availableCount++;
                    defaultSourceType = sourceType;
                }
            }
        }
        if (availableCount == 0) {
            return nil;
        }
        self.pickerController = [UIImagePickerController new];
        self.pickerController.delegate = self;
        self.alertPreferredStyle = -1;
    }
    return self;
}

- (NSDictionary *)sourceLocalizationMap {
    if (!_sourceLocalizationMap) {
        _sourceLocalizationMap =
        @{
          @(UIImagePickerControllerSourceTypePhotoLibrary) : @"Photo Library",
          @(UIImagePickerControllerSourceTypeCamera) : @"Camera",
          @(UIImagePickerControllerSourceTypeSavedPhotosAlbum) : @"Saved Photos Album",
          };
    }
    return _sourceLocalizationMap;
}



#pragma mark -
#pragma mark - Properties forwarding

@dynamic cameraCaptureMode;
@dynamic cameraDevice;
@dynamic cameraFlashMode;

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.pickerController;
}



#pragma mark -
#pragma mark - UIAlertConfigurator

- (UIAlertControllerStyle)alertControllerPreferredStyle {
    if (self.alertPreferredStyle >= 0) {
        return self.alertPreferredStyle;
    } else {
        BOOL iPadDevice = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        return iPadDevice ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet;
    }
}

- (UIView *)alertControllerPresentationSourceView {
    return self.sourceView;
}

- (CGRect)alertControllerPresentationSourceRect {
    return self.sourceRect;
}

- (UIPopoverArrowDirection)alertControllerPresentationPermittedArrowDirections {
    return self.permittedArrowDirections;
}



#pragma mark -
#pragma mark - Protected

- (void)showOnViewController:(__kindof UIViewController *)viewController {
    if (availableCount > 1) {
        [self showAlertOnViewController:viewController];
    } else {
        [self selectSource:defaultSourceType];
        [viewController presentViewController:self.pickerController
                                     animated:true completion:nil];
    }
}

- (void)showAlertOnViewController:(UIViewController *)viewController {
    NSMutableArray *actions = [NSMutableArray new];
    
    for (NSInteger sourceTypeIndex = 0; sourceTypeIndex < AKImagePickerSupportedImageSourcesCount; sourceTypeIndex++) {
        if (availableIndexes[sourceTypeIndex]) {
            UIImagePickerControllerSourceType sourceType = AKImagePickerSupportedImageSources[sourceTypeIndex];
            dispatch_block_t actionHandler = ^{
                [self selectSource:sourceType];
                [viewController presentViewController:self.pickerController
                                             animated:true completion:nil];
            };
            UIAlertAction *action = nil;
            if (self.delegate) {
                action = [self.delegate alertActionForImagePicker:self sourceType:sourceType withHandler:^(UIAlertAction *action) {
                    actionHandler();
                }];
            } else {
                NSString *localizationKey = self.sourceLocalizationMap[@(sourceType)];
                action = UIKitLocalizedActionDefaultStyleMake(localizationKey, actionHandler);
            }
            [actions addObject:action];
        }
    }
    [viewController showAlert:self.alertTitle
                      message:self.alertMessage
                      actions:actions
                       cancel:[self completionWithImage:nil]
                 configurator:self];
}

- (void)selectSource:(UIImagePickerControllerSourceType)sourceType {
    BOOL iPad = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
    BOOL sourceIsCamera = sourceType == UIImagePickerControllerSourceTypeCamera;
    self.pickerController.allowsEditing = self.allowsEditing && (!iPad || sourceIsCamera);
    self.pickerController.sourceType = sourceType;
}

- (dispatch_block_t)completionWithImage:(UIImage *)image {
    return ^{
        self.completionBlock(image);
    };
}



#pragma mark -
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = picker.allowsEditing ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:true completion:[self completionWithImage:image]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:[self completionWithImage:nil]];
}

@end



#pragma mark -

@implementation UIViewController(AKImagePicker)

- (void)showImagePicker:(AKImagePicker *)picker {
    [self showImagePicker:picker sourceView:nil sourceRect:CGRectNull];
}

- (void)showImagePicker:(AKImagePicker *)picker sourceView:(UIView *)sourceView {
    [self showImagePicker:picker sourceView:sourceView sourceRect:CGRectNull];
}

- (void)showImagePicker:(AKImagePicker *)picker sourceView:(UIView *)sourceView sourceRect:(CGRect)sourceRect {
    picker.sourceView = sourceView;
    picker.sourceRect = sourceRect;
    [picker showOnViewController:self];
}

@end
