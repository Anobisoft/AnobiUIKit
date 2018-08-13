//
//  AKTheme.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 06.04.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+AK.h"

static NSString * const AKThemeConfigKeyedColorsKey = @"KeyedColors";
static NSString * const AKThemeConfigIndexedColorsKey = @"IndexedColors";
static NSString * const AKThemeConfigBarStyleKey = @"BarStyle";

@interface AKTheme : NSObject

+ (instancetype)themeNamed:(NSString *)name withConfig:(NSDictionary *)config;

@property (readonly) NSString *name;
@property (readonly) NSDictionary<NSString *, UIColor *> *keyedColors;
@property (readonly) NSArray<UIColor *> *indexedColors;
@property (readonly) UIBarStyle barStyle;
@property (readonly) UIStatusBarStyle statusBarStyle;

- (UIColor *)objectForKeyedSubscript:(NSString *)key;
- (UIColor *)objectAtIndexedSubscript:(NSUInteger)idx;

@end

