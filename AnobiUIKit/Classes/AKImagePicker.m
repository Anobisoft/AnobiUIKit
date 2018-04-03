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
        if (options != AKImagePickerSourceOptionAuto) {
            for (int sourceType = 0; sourceType < 3; sourceType++) {
                if (options & (1 << sourceType)) {
                    availableCount += available[sourceType] = SourceAvailable(sourceType);
                }
            }
        } else {
            for (NSInteger sourceType = 0; sourceType < 3; sourceType++) {
                availableCount += available[sourceType] = SourceAvailable(sourceType);
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

UIAlertAction *UILocalizedActionMake(NSString *localizationKey, dispatch_block_t handler) {
    return UIAlertActionDefaultStyleMake([[NSBundle bundleForClass:UIApplication.class] localizedStringForKey:localizationKey value:nil table:nil], handler);
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
                [alert addAction:UILocalizedActionMake(sourceLocalizationKeys[sourceType], ^{
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
                [self selectSource:sourceType];
                [viewController presentViewController:self.pickerController
                                             animated:true completion:nil];
                break;
            }
        }
    }
}

- (void)selectSource:(UIImagePickerControllerSourceType)sourceType {
    self.pickerController.allowsEditing = self.allowsEditing && ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad || sourceType == UIImagePickerControllerSourceTypeCamera);
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
#pragma mark -

@implementation UIViewController(AKImagePicker)

- (void)showImagePicker:(AKImagePicker *)picker {
    [self showImagePicker:picker sourceView:nil sourceRect:CGRectNull];
}

- (void)showImagePicker:(AKImagePicker *)picker sourceView:(UIView *)sourceView sourceRect:(CGRect)sourceRect {
    [picker viewController:self sourceView:sourceView sourceRect:sourceRect];
}

@end
