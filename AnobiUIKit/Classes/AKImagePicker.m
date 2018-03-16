//
//  AKImagePicker.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 12.09.2017.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKImagePicker.h"
#import <AnobiKit/AnobiKit.h>

@interface AKImagePicker() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
- (void)viewController:(UIViewController *)viewController
            sourceView:(UIView *)sourceView
            sourceRect:(CGRect)sourceRect;
@end

@implementation AKImagePicker {
    BOOL available[3];
    NSInteger availableCount;
    void (^completionBlock)(UIImage *image);
}

static id instance = nil;

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
    if (instance) return instance;
    return instance = [[self alloc] initWithCompletion:completion];
}

BOOL SourceAvailable(UIImagePickerControllerSourceType sourceType) {
    return [UIImagePickerController isSourceTypeAvailable:sourceType];
}

- (instancetype)initWithSourceOptions:(AKImagePickerSourceOption)options completion:(void (^)(UIImage *image))completion {
    if (self = [super init]) {
        self.alertPreferredStyle = UIAlertControllerStyleActionSheet;
        completionBlock = completion;
        availableCount = 0;
        for (int sourceType = 0; sourceType < 3; sourceType++) {
            if (options & (1 << sourceType)) {
                availableCount += available[sourceType] = SourceAvailable(sourceType);
            }
        }
    }
    return self;
}

- (instancetype)initWithCompletion:(void (^)(UIImage *image))completion {
    if (self = [super init]) {
        self.alertPreferredStyle = UIAlertControllerStyleActionSheet;
        completionBlock = completion;
        availableCount = 0;
        for (NSInteger sourceType = 0; sourceType < 3; sourceType++) {
            availableCount += available[sourceType] = SourceAvailable(sourceType);
        }
    }
    return availableCount ? self : nil;
}

- (void)viewController:(UIViewController *)viewController
            sourceView:(UIView *)sourceView
            sourceRect:(CGRect)sourceRect {
    if (availableCount > 1) {
        NSArray *sourceLocalizationKeys = @[@"Photo Library", @"Camera", @"Saved Photos Album"];
        UIAlertControllerStyle style = UIAlertControllerStyleAlert;
        if (self.alertPreferredStyle == UIAlertControllerStyleActionSheet && sourceView) {
            style = self.alertPreferredStyle;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.alertTitle
                                                                       message:self.alertMessage
                                                                preferredStyle:style];
        
        for (NSInteger sourceType = 0; sourceType < 3; sourceType++) {
            if (available[sourceType]) {
                UIAlertAction *action =
                [UIAlertAction actionWithTitle:[[NSBundle UIKitBundle] localizedStringForKey:sourceLocalizationKeys[sourceType]]
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * _Nonnull action) {
                                           UIImagePickerController *pickerController = [self imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                           [viewController presentViewController:pickerController animated:true completion:nil];
                                       }];
                [alert addAction:action];
            }
        }
        
        [alert addAction:[UIAlertAction actionWithTitle:[[NSBundle UIKitBundle] localizedStringForKey:@"Cancel"]
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction * _Nonnull action) { }]];
        
        alert.popoverPresentationController.sourceView = sourceView;
        if (CGRectIsNull(sourceRect)) {
            sourceRect.origin = sourceView.center;
            sourceRect.size = CGSizeMake(1, 1);
        }
        alert.popoverPresentationController.sourceRect = sourceRect;
//        alert.popoverPresentationController.permittedArrowDirections = UIMenuControllerArrowUp;
        [viewController presentViewController:alert animated:true completion:nil];
    } else {
        for (NSInteger sourceType = 0; sourceType < 3; sourceType++) {
            if (available[sourceType]) {
                [viewController presentViewController:[self imagePickerControllerWithSourceType:sourceType]
                                             animated:true completion:nil];
                break;
            }
        }
    }
}

- (UIImagePickerController *)imagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = self.allowsEditing && ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad || sourceType == UIImagePickerControllerSourceTypeCamera);
    picker.sourceType = sourceType;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        picker.cameraDevice = self.cameraDevice;
        picker.cameraCaptureMode = self.cameraCaptureMode;
        picker.cameraFlashMode = self.cameraFlashMode;
    }
    return picker;
}

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



@implementation UIViewController(AKImagePicker)

- (void)showImagePicker:(AKImagePicker *)picker {
    [self showImagePicker:picker sourceView:nil sourceRect:CGRectNull];
}

- (void)showImagePicker:(AKImagePicker *)picker sourceView:(UIView *)sourceView sourceRect:(CGRect)sourceRect {
    [picker viewController:self sourceView:sourceView sourceRect:sourceRect];
}

@end
