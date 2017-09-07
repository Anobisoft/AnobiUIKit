//
//  AKTheme.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 06.04.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKTheme.h"
#import <AnobiKit/AKConfig.h>
#import "UIColor+AnobiUIKit.h"

#define AKThemeConfigName @"AKThemes"
#define AKThemeConfigKey_Themes @"Themes"
#define AKThemeConfigKey_BarStyle @"BarStyle"
#define AKThemeConfigKey_KeyedColors @"KeyedColors"
#define AKThemeConfigKey_IndexedColors @"IndexedColors"
#define AKThemeConfigKey_DefaultTheme @"DefaultTheme"

#define AKThemeUDKey_CurrentThemeName @"AKThemeCurrentThemeName"

@implementation AKTheme {

}

static NSMutableDictionary <NSString *, AKTheme *> *instances;
static NSDictionary <NSString *, id> *themes;
static NSString *currentThemeName;

+ (void)initialize {
    [super initialize];
    NSDictionary *configThemes = [AKConfig<NSDictionary *> shared][AKThemeConfigName][AKThemeConfigKey_Themes];
    NSMutableDictionary <NSString *, NSDictionary *> *themesMutable = [NSMutableDictionary new];
    NSMutableDictionary <NSString *, id> *themeMutable = [NSMutableDictionary new];
    NSMutableDictionary <NSString *, UIColor *> *colorsMutable = [NSMutableDictionary new];
    NSMutableArray <UIColor *> *iconColorsMutable = [NSMutableArray new];
    
    for (NSString *themeName in configThemes.allKeys) {
        NSDictionary <NSString *, id> *configTheme = configThemes[themeName];
        for (NSString *key in configTheme.allKeys) {
            if ([key isEqualToString:AKThemeConfigKey_KeyedColors]) {
                NSDictionary <NSString *, NSString *> *configThemeColors = configTheme[key];
                for (NSString *colorKey in configThemeColors.allKeys) {
                    NSString *colorString = configThemeColors[colorKey];
                    UIColor *color = [UIColor colorWithHexString:colorString];
                    colorsMutable[colorKey] = color;
                }
                themeMutable[key] = colorsMutable.copy;
                [colorsMutable removeAllObjects];
            } else if ([key isEqualToString:AKThemeConfigKey_IndexedColors]) {
                NSArray <NSString *> *configThemeIconColors = configTheme[key];
                for (NSString *colorString in configThemeIconColors) {
                    UIColor *color = [UIColor colorWithHexString:colorString];
                    [iconColorsMutable addObject:color];
                }
                themeMutable[key] = iconColorsMutable.copy;
                [iconColorsMutable removeAllObjects];
            } else {
                themeMutable[key] = configTheme[key];
            }
        }
        themesMutable[themeName] = themeMutable.copy;
        [themeMutable removeAllObjects];
    }
    themes = themesMutable.copy;
    
    currentThemeName = [[NSUserDefaults standardUserDefaults] objectForKey:AKThemeUDKey_CurrentThemeName];
    if (!currentThemeName) currentThemeName = [AKConfig shared][AKThemeConfigName][AKThemeConfigKey_DefaultTheme];
    if (!currentThemeName) currentThemeName = configThemes.allKeys.firstObject;
    if (!currentThemeName) @throw NSUndefinedKeyException;
}


+ (instancetype)currentTheme {
    /* NSInteger hour = [[NSCalendar currentCalendar] component:NSCalendarUnitHour fromDate:[NSDate date]];
    BOOL day = (hour > 10 && hour < 19);
//    day = [[NSCalendar currentCalendar] component:NSCalendarUnitSecond fromDate:[NSDate date]] % 30 < 15;
    if (day) return [self themeNamed:@"Light"];
    else */ return [self themeNamed:currentThemeName];
}

+ (void)setCurrentThemeNamed:(NSString *)name {
    currentThemeName = name;
    [[NSUserDefaults standardUserDefaults] setObject:currentThemeName forKey:AKThemeUDKey_CurrentThemeName];
}

+ (instancetype)themeNamed:(NSString *)name {
    id instance = instances[name];
    if (!instance) {
        instance = [[self alloc] initWithName:name];
        if (instance) instances[name] = instance;
    }
    if (instance) currentThemeName = name;
    return instance;
}

+ (NSArray<NSString *> *)allNames {
    return themes.allKeys;
}

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        NSDictionary *themeDict = themes[name];
        
        if (!themeDict) return nil;
        else {
            _name = name;
            _keyedColors = themeDict[AKThemeConfigKey_KeyedColors];
            _barStyle = [themeDict[AKThemeConfigKey_BarStyle] isEqualToString:@"Black"] || [themeDict[AKThemeConfigKey_BarStyle] isEqualToString:@"Dark"] ? UIBarStyleBlack : UIBarStyleDefault;
            _indexedColors = themeDict[AKThemeConfigKey_IndexedColors];
        }
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
