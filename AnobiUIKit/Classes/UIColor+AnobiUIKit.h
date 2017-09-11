//
//  UIColor+AnobiUIKit.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 16.06.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorWith(rgbHex, alfa) [UIColor colorWithHexRGB:rgbHex alpha:alfa]

@interface UIColor (AnobiUIKit)

+ (instancetype)colorWithHexString:(NSString *)string;
+ (instancetype)colorWithHexString:(NSString *)string alfa:(CGFloat)alfa;
+ (instancetype)colorWithHexRGB:(unsigned)icolor alfa:(CGFloat)alfa;

@end
