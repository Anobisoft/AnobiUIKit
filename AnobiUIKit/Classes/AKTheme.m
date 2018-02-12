//
//  AKTheme.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 06.04.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKTheme.h"
#import <AnobiKit/AKConfigManager.h>
#import "UIColor+Hex.h"

@implementation AKTheme

+ (instancetype)themeNamed:(NSString *)name withConfig:(NSDictionary *)config {
    return [[self alloc] initWithName:name withConfig:config];
}

- (instancetype)initWithName:(NSString *)name withConfig:(NSDictionary *)config {
    if (self = [super init]) {
        _name = name;
        
        NSDictionary<NSString *, NSString *> *keyedColorsRepresentation = config[AKThemeConfigKey_KeyedColors];
        NSMutableDictionary<NSString *, UIColor *> *keyedColorsM = [NSMutableDictionary new];
        for (NSString *key in keyedColorsRepresentation) {
            UIColor *color = [UIColor colorWithHexString:keyedColorsRepresentation[key]];
            if (color) keyedColorsM[key] = color;
        }
        _keyedColors = keyedColorsM.copy;
        
        NSArray<NSString *> *indexedColorsRepresentation = config[AKThemeConfigKey_IndexedColors];
        NSMutableArray<UIColor *> *indexedColorsM = [NSMutableArray new];
        for (NSString *colorHexRepresentation in indexedColorsRepresentation) {
            UIColor *color = [UIColor colorWithHexString:colorHexRepresentation];
            if (color) [indexedColorsM addObject:color];
        }
        _indexedColors = indexedColorsM.copy;
        
        NSString *barStyleString = config[AKThemeConfigKey_BarStyle];
        BOOL black = [barStyleString isEqualToString:@"Black"] || [barStyleString isEqualToString:@"Dark"];
        _barStyle = black ? UIBarStyleBlack : UIBarStyleDefault;
        _statusBarStyle = black ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    }
    return self;
}

- (UIColor *)objectForKeyedSubscript:(NSString *)key {
    return _keyedColors[key];
}

- (UIColor *)objectAtIndexedSubscript:(NSUInteger)idx {
    return _indexedColors[idx];
}

@end
