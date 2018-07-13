//
//  AKImagePicker.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 12.09.2017.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKImagePicker.h"
#import "UIViewController+AK.h"

@interface AKImagePicker() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
- (void)viewController:(UIViewController *)viewController sourceView:(UIView *)sourceView sourceRect:(CGRect)sourceRect;
@property (nonatomic) UIImagePickerController *pickerController;
@end

@implementation AKImagePicker {
    NSDictionary *sourceLocalizationMap;
    BOOL available[supportedImageSourcesCount];
    NSInteger availableCount;
    void (^completionBlock)(UIImage *image);
}

static AKImagePicker *instance = nil;

+ (instancetype)pickerWithSourceType:(UIImagePickerControllerSourceType)sourceType completion:(void (^)(UIImage *image))completion {
    return [self pickerWithSourceOptions:1 << sourceType completion:completion];
}

+ (instancetype)pickerWithSourceOptions:(AKImagePickerSourceOption)options completion:(void (^)(UIImage *image))completion {
    if (options == AKImagePickerSourceOptionAuto) {
        return [self pickerWithCompletion:completion];
    } else {
        return instance = [[self alloc] initWithSourceOptions:(AKImagePickerSourceOption)options completion:completion];
    }
}

+ (instancetype)pickerWithCompletion:(void (^)(UIImage *image))completion {
    if (instance) {
        instance->completionBlock = completion;
        return instance;
    }
    return instance = [[self alloc] initWithCompletion:completion];
}

BOOL SourceAvailable(UIImagePickerControllerSourceType sourceType) {
    return [UIImagePickerController isSourceTypeAvailable:sourceType];
}

- (instancetype)initWithSourceOptions:(AKImagePickerSourceOption)options completion:(void (^)(UIImage *image))completion {
    if (self = [super init]) {
        sourceLocalizationMap =
        @{
          @(UIImagePickerControllerSourceTypePhotoLibrary) : @"Photo Library",
          @(UIImagePickerControllerSourceTypeCamera) : @"Camera",
          @(UIImagePickerControllerSourceTypeSavedPhotosAlbum) : @"Saved Photos Album",
          };
        
        self.alertPreferredStyle = UIAlertControllerStyleActionSheet;
        completionBlock = completion;
        availableCount = 0;
        if (options != AKImagePickerSourceOptionAuto) {
            for (int sourceTypeIndex = 0; sourceTypeIndex < supportedImageSourcesCount; sourceTypeIndex++) {
                UIImagePickerControllerSourceType sourceType = supportedImageSources[sourceTypeIndex];
                if (options & (1 << sourceType)) {
                    availableCount += available[sourceTypeIndex] = SourceAvailable(sourceType);
                }
            }
        } else {
            for (NSInteger sourceTypeIndex = 0; sourceTypeIndex < supportedImageSourcesCount; sourceTypeIndex++) {
                UIImagePickerControllerSourceType sourceType = supportedImageSources[sourceTypeIndex];
                availableCount += available[sourceTypeIndex] = SourceAvailable(sourceType);
            }
        }
        self.pickerController = [UIImagePickerController new];
        self.pickerController.delegate = self;
    }
    return availableCount ? self : nil;
}

- (instancetype)initWithCompletion:(void (^)(UIImage *image))completion {
    return [self initWithSourceOptions:AKImagePickerSourceOptionAuto completion:completion];
}



#pragma mark -
#pragma mark - Properties forwarding

@dynamic cameraCaptureMode;
@dynamic cameraDevice;
@dynamic cameraFlashMode;

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self respondsToSelector:aSelector]) return self;
    else return self.pickerController;
}



#pragma mark -
#pragma mark - Alert

- (void)viewController:(UIViewController *)viewController
            sourceView:(UIView *)sourceView
            sourceRect:(CGRect)sourceRect {
    
    if (availableCount > 1) {
        [self showAlertOnViewController:viewController sourceView:sourceView sourceRect:sourceRect];
    } else {
        for (NSInteger sourceTypeIndex = 0; sourceTypeIndex < supportedImageSourcesCount; sourceTypeIndex++) {
            if (available[sourceTypeIndex]) {
                UIImagePickerControllerSourceType sourceType = supportedImageSources[sourceTypeIndex];
                [self selectSource:sourceType];
                [viewController presentViewController:self.pickerController
                                             animated:true completion:nil];
                break;
            }
        }
    }
}

- (void)showAlertOnViewController:(UIViewController *)viewController
                       sourceView:(UIView *)sourceView
                       sourceRect:(CGRect)sourceRect {
    
    UIAlertControllerStyle style = UIAlertControllerStyleAlert;
    BOOL iPhone = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
    if (iPhone) {
        style = self.alertPreferredStyle;
    } else {
        if (self.alertPreferredStyle == UIAlertControllerStyleActionSheet && sourceView) {
            style = UIAlertControllerStyleActionSheet;
            if (CGRectIsNull(sourceRect)) {
                CGPoint centerPoint = sourceView.center;
                sourceRect = CGRectMake(centerPoint.x, centerPoint.y, 1, 1);
            }
        }
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.alertTitle
                                                                   message:self.alertMessage
                                                            preferredStyle:style];
    
    for (NSInteger sourceTypeIndex = 0; sourceTypeIndex < supportedImageSourcesCount; sourceTypeIndex++) {
        if (available[sourceTypeIndex]) {
            UIImagePickerControllerSourceType sourceType = supportedImageSources[sourceTypeIndex];
            NSString *localizationKey = sourceLocalizationMap[@(sourceType)];
            [alert addAction:UILocalizedActionMake(localizationKey, ^{
                [self selectSource:sourceType];
                [viewController presentViewController:self.pickerController
                                             animated:true completion:nil];
            })];
        }
    }
    
    [alert addAction:UIAlertCancelAction(^{
        instance = nil;
        self->completionBlock(nil);
    })];
    
    alert.popoverPresentationController.sourceView = sourceView;
    alert.popoverPresentationController.sourceRect = sourceRect;
    alert.popoverPresentationController.permittedArrowDirections = self.permittedArrowDirections;
    [viewController presentViewController:alert animated:true completion:nil];
}

- (void)selectSource:(UIImagePickerControllerSourceType)sourceType {
    BOOL iPad = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
    BOOL sourceIsCamera = sourceType == UIImagePickerControllerSourceTypeCamera;
    self.pickerController.allowsEditing = self.allowsEditing && (!iPad || sourceIsCamera);
    self.pickerController.sourceType = sourceType;
}



#pragma mark -
#pragma mark - Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = picker.allowsEditing ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:true completion:^{
        instance = nil;
        self->completionBlock(image);
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:^{
        instance = nil;
        self->completionBlock(nil);
    }];
}

@end



#pragma mark -
#pragma mark - UIViewController

@implementation UIViewController(AKImagePicker)

- (void)showImagePicker:(AKImagePicker *)picker {
    [self showImagePicker:picker sourceView:nil sourceRect:CGRectNull];
}

- (void)showImagePicker:(AKImagePicker *)picker sourceView:(UIView *)sourceView sourceRect:(CGRect)sourceRect {
    [picker viewController:self sourceView:sourceView sourceRect:sourceRect];
}

@end
