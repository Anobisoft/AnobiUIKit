//
//  UIColor+AnobiUIKit.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 16.06.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorWith(rgbHexValue, alfa) \
[UIColor colorWithRed:((CGFloat)((rgbHexValue & 0xFF0000) >> 16))/255.0 \
green:((CGFloat)((rgbHexValue & 0x00FF00) >>  8))/255.0 \
blue:((CGFloat)((rgbHexValue & 0x0000FF) >>  0))/255.0 \
alpha:alfa]

@interface UIColor (AnobiUIKit)

+ (instancetype)colorWithHexRGB:(unsigned)icolor alfa:(CGFloat)alfa;
+ (instancetype)colorWithHexString:(NSString *)string alfa:(CGFloat)alfa;
+ (instancetype)colorWithHexString:(NSString *)string;

@end
