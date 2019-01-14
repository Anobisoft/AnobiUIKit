//
//  AKThemeManager.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 12.02.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import "AKThemeManager.h"

static NSString * const UDKey_AKTheme_CurrentThemeName = @"AKThemeManager.currentThemeName";

@implementation AKThemeManager {
    NSDictionary<NSString *, AKTheme *> *themes;
    NSString *currentThemeName;
}

static id instance;
+ (instancetype)managerWithConfig:(NSDictionary *)config {
    instance = [[self alloc] initWithConfig:config];
    return instance;
}

+ (instancetype)manager {
    return instance;
}

- (instancetype)initWithConfig:(NSDictionary *)config {
    if (self = [super init]) {
        if (![config isKindOfClass:NSDictionary.class]) {
            @throw [NSException exceptionWithName:@"AKThemeManagerInvalidConfigTypeException"
                                           reason:@"unexpected config type" userInfo:@{@"сonfig class" : [config class]}];
            return nil;
        }

        NSMutableDictionary<NSString *, AKTheme *> *tmp = [NSMutableDictionary new];
        for (NSString *themeName in config.allKeys) {
            AKTheme *theme = [AKTheme themeNamed:themeName withConfig:config[themeName]];
            if (theme) {
                tmp[themeName] = theme;
            }
        }
        NSArray<NSString *> *allKeys = tmp.allKeys;
        if (!allKeys.count) {
            @throw [NSException exceptionWithName:@"AKThemeManagerEmptyConfigException" reason:@"no themes configured" userInfo:nil];
            return nil;
        }
        themes = tmp.copy;
        
        currentThemeName = [[NSUserDefaults standardUserDefaults] objectForKey:UDKey_AKTheme_CurrentThemeName];
        if (!(currentThemeName && [allKeys containsObject:currentThemeName])) {
            currentThemeName = allKeys.firstObject;
        }
    }
    return self;
}

- (NSArray<AKTheme *> *)allThemes {
    return themes.allValues;
}

- (NSArray<NSString *> *)allNames {
    return themes.allKeys;
}

- (AKTheme *)themeWithName:(NSString *)name {
    return themes[name];
}

- (AKTheme *)objectForKeyedSubscript:(NSString *)name {
    return [self themeWithName:name];
}

- (void)setCurrentThemeName:(NSString *)name {
    NSArray<NSString *> *allNames = self.allNames;
    if ([allNames containsObject:name]) {
        currentThemeName = name;
        [[NSUserDefaults standardUserDefaults] setObject:currentThemeName forKey:UDKey_AKTheme_CurrentThemeName];
    } else {
        @throw [NSException exceptionWithName:@"AKThemeManagerInvalidConfigName" reason:@"" userInfo:nil];
    }
}

- (AKTheme *)currentTheme {
    return [self themeWithName:currentThemeName];
}

- (void)setCurrentTheme:(AKTheme *)currentTheme {
    currentThemeName = currentTheme.name;
}

@end
