//
//  UIImage+Resize.h
//  Pods
//
//  Created by Stanislav Pletnev on 14.09.17.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)resizedImageWithSideSizeMax:(CGFloat)sideSizeMax;
- (UIImage *)resizedImage:(CGSize)newSize;

@end
