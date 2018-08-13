//
//  UIImage+Resize.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 14.09.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)resizedImageWithSideSizeMax:(CGFloat)sideSizeMax;
- (UIImage *)resizedImageWithScale:(CGFloat)scale;
- (UIImage *)resizedImage:(CGSize)newSize;

- (NSData *)JPEGRepresentationDataWithCompression:(CGFloat)compression;
- (NSData *)PNGRepresentationData;

- (NSData *)resizedPNGRepresentationWithDataLengthMax:(NSUInteger)dataLMax;
- (NSData *)resizedJPEGRepresentationWithDataLengthMax:(NSUInteger)dataLMax compression:(CGFloat)compression;

@end
