//
//  UIImage+Resize.m
//  Pods
//
//  Created by Stanislav Pletnev on 14.09.17.
//
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)resizedImageWithSideSizeMax:(CGFloat)sideSizeMax {
    if (self.size.height > sideSizeMax || self.size.width > sideSizeMax) {
        CGSize scaledSize = CGSizeMake(sideSizeMax * (self.size.height > self.size.width ? self.size.width / self.size.height : 1),
                                       sideSizeMax * (self.size.height < self.size.width ? self.size.height / self.size.width : 1));
        return [self resizedImage:scaledSize];
    } else {
        return self;
    }
}

- (UIImage *)resizedImage:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

@end
