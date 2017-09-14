//
//  UIColor+Hex.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 16.06.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorWith(rgbHex, alpha) [UIColor colorWithHexRGB:rgbHex alpha:alpha]

@interface UIColor (Hex)

+ (instancetype)colorWithHexString:(NSString *)string;
+ (instancetype)colorWithHexString:(NSString *)string alpha:(CGFloat)alpha;
+ (instancetype)colorWithHexRGB:(unsigned)icolor alpha:(CGFloat)alpha;

@end
