//
//  UIImage+Resize.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 14.09.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
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

- (UIImage *)resizedImageWithScale:(CGFloat)scale {
    CGSize scaledSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    if (self.size.width == scaledSize.width) {
        return self;
    } else {
        return [self resizedImage:scaledSize];
    }    
}

- (UIImage *)resizedImage:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (NSData *)JPEGRepresentationDataWithCompression:(CGFloat)compression {
    return UIImageJPEGRepresentation(self, compression);
}

- (NSData *)PNGRepresentationData {
    return UIImagePNGRepresentation(self);
}

typedef NSData *(^ImageEncodingBlock)(UIImage *origin);

- (NSData *)resizedImageRepresentationWithEncodingBlock:(ImageEncodingBlock)encoding dataLengthMax:(NSUInteger)dataLengthMax {
    NSData *data = encoding(self);
    CGFloat dataLength = data.length;
    
    while (dataLength > dataLengthMax) {
        CGSize size = self.size;
        CGFloat maxSide = MAX(size.width, size.height);
        CGFloat newSideSize = sqrt(dataLengthMax / dataLength) * maxSide;
        UIImage *resizedImage = [self resizedImageWithSideSizeMax:newSideSize];
        data = encoding(resizedImage);
        dataLength = data.length;
    }
    return data;    
}

- (NSData *)resizedPNGRepresentationWithDataLengthMax:(NSUInteger)dataLengthMax {
    ImageEncodingBlock encodingBlock = ^NSData *(UIImage *origin) {
        return origin.PNGRepresentationData;
    };
    return [self resizedImageRepresentationWithEncodingBlock:encodingBlock dataLengthMax:dataLengthMax];
}

- (NSData *)resizedJPEGRepresentationWithDataLengthMax:(NSUInteger)dataLengthMax compression:(CGFloat)compression {
    ImageEncodingBlock encodingBlock = ^NSData *(UIImage *origin) {
        return [origin JPEGRepresentationDataWithCompression:compression];
    };
    return [self resizedImageRepresentationWithEncodingBlock:encodingBlock dataLengthMax:dataLengthMax];
}


@end
