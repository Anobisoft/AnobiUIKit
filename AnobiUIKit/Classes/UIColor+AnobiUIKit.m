//
//  UIColor+AnobiUIKit.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 16.06.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "UIColor+AnobiUIKit.h"

@implementation UIColor (AnobiUIKit)

+ (instancetype)colorWithHexString:(NSString *)string alfa:(CGFloat)alfa {
    NSString *trim = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *hex = [trim stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    unsigned rgbColor = 0;
    [scanner scanHexInt:&rgbColor];
    return [self colorWithHexRGB:rgbColor alfa:alfa];
}

+ (instancetype)colorWithHexString:(NSString *)string {
    return [self colorWithHexString:string alfa:1.0];
}

+ (instancetype)colorWithHexRGB:(unsigned)rgbColor alfa:(CGFloat)alfa {
    return [self colorWithRed:(CGFloat)((rgbColor & 0xFF0000) >> 0x10) / 255.0
                        green:(CGFloat)((rgbColor & 0x00FF00) >> 0x08) / 255.0
                         blue:(CGFloat)((rgbColor & 0x0000FF) >> 0x00) / 255.0
                        alpha:alfa];
}

@end
