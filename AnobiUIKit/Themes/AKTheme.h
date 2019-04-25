//
//  AKTheme.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 06.04.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const AKThemeConfigAppearanceSchemaKey = @"AppearanceSchema";
static NSString * const AKThemeConfigAppearanceContainedInInstancesOfClassesKey = @"ContainedInInstancesOfClasses";
static NSString * const AKThemeConfigAppearanceColorSchemaKey = @"ColorSchema";
static NSString * const AKThemeConfigAppearanceBarStyleSchemaKey = @"BarStyleSchema";


static NSString * const AKThemeConfigKeyedColorsKey = @"KeyedColors";
static NSString * const AKThemeConfigIndexedColorsKey = @"IndexedColors";
static NSString * const AKThemeConfigStatusBarStyleKey = @"StatusBarStyle";

@interface AKTheme : NSObject

+ (instancetype)themeNamed:(NSString *)name withConfig:(NSDictionary *)config;

@property (readonly) NSString *name;
@property (readonly) NSDictionary<NSString *, UIColor *> *keyedColors;
@property (readonly) NSArray<UIColor *> *indexedColors;
@property (readonly) UIStatusBarStyle statusBarStyle;

- (UIColor *)objectForKeyedSubscript:(NSString *)key;
- (UIColor *)objectAtIndexedSubscript:(NSUInteger)idx;

- (void)applyAppearanceSchema;

@end

