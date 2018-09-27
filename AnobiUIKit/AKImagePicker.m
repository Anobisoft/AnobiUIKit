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
@property (nonatomic, assign) CGRect sourceRect;
- (void)showOnViewController:(__kindof UIViewController *)viewController;

@property (nonatomic) UIImagePickerController *pickerController;
@property (nonatomic) NSDictionary *sourceLocalizationMap;

@end

@implementation AKImagePicker {
    BOOL availableIndexes[supportedImageSourcesCount];
    UIImagePickerControllerSourceType defaultSourceType;
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
       
        self.alertPreferredStyle = UIAlertControllerStyleActionSheet;
        completionBlock = completion;
        
        if (options == AKImagePickerSourceOptionAuto) {
            options = AKImagePickerSourceOptionPhotoLibrary + AKImagePickerSourceOptionCamera + AKImagePickerSourceOptionSavedPhotosAlbum;
        }
        availableCount = 0;
        for (int sourceTypeIndex = 0; sourceTypeIndex < supportedImageSourcesCount; sourceTypeIndex++) {
            UIImagePickerControllerSourceType sourceType = supportedImageSources[sourceTypeIndex];
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

- (instancetype)initWithCompletion:(void (^)(UIImage *image))completion {
    return [self initWithSourceOptions:AKImagePickerSourceOptionAuto completion:completion];
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
#pragma mark - Alert

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
    
    for (NSInteger sourceTypeIndex = 0; sourceTypeIndex < supportedImageSourcesCount; sourceTypeIndex++) {
        if (availableIndexes[sourceTypeIndex]) {
            UIImagePickerControllerSourceType sourceType = supportedImageSources[sourceTypeIndex];
            NSString *localizationKey = self.sourceLocalizationMap[@(sourceType)];
            UIAlertAction *action = UILocalizedActionDefaultStyleMake(localizationKey, ^{
                [self selectSource:sourceType];
                [viewController presentViewController:self.pickerController
                                             animated:true completion:nil];
            });
            [actions addObject:action];
        }
    }
    
    [actions addObject:UIAlertCancelAction(^{
        instance = nil;
        self->completionBlock(nil);
    })];
    
    [viewController showAlert:self.alertTitle message:self.alertMessage actions:actions configurator:self];
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
    picker.sourceView = sourceView;
    picker.sourceRect = sourceRect;
    [picker showOnViewController:self];
}

@end
