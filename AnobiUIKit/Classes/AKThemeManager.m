//
//  AKThemeManager.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 12.02.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import "AKThemeManager.h"

#define AKThemeUDKey_CurrentThemeName @"AKThemeCurrentThemeName"

@implementation AKThemeManager {
    NSDictionary<NSString *, NSDictionary *> *themeConfigs;
    NSArray<NSString *> *allNames;
    NSCache<NSString *, AKTheme *> *themesCache;
    NSString *currentThemeName;
}

static id instance;
+ (instancetype)managerWithConfigName:(NSString *)configName {
    instance = [[self alloc] initWithConfigName:configName];
    return instance;
}

+ (instancetype)manager {
    return instance;
}

- (instancetype)initWithConfigName:(NSString *)configName {
    if (self = [super init]) {
        themeConfigs = [AKConfigManager manager][configName];
        if (![themeConfigs isKindOfClass:[NSDictionary class]]) {
            @throw [NSException exceptionWithName:@"AKThemeManagerInvalidConfigTypeException" reason:@"unexpected config type" userInfo:@{@"themeConfigs class" : [themeConfigs class]}];
        }
        allNames = themeConfigs.allKeys;
        if (!allNames.count) {
            @throw [NSException exceptionWithName:@"AKThemeManagerEmptyConfigException" reason:@"no themes configured" userInfo:nil];
        }
        themesCache = [NSCache new];
        themesCache.totalCostLimit = 0x4000; //16KB
        currentThemeName = [[NSUserDefaults standardUserDefaults] objectForKey:AKThemeUDKey_CurrentThemeName];
        if (! (currentThemeName && [allNames containsObject:currentThemeName])) {
            currentThemeName = allNames.firstObject;
        }
    }
    return self;
}

- (NSUInteger)cacheCostLimit {
    return themesCache.totalCostLimit;
}

- (void)setCacheCostLimit:(NSUInteger)cacheCostLimit {
    themesCache.totalCostLimit = cacheCostLimit;
}

- (NSArray<NSString *> *)allNames {
    return allNames;
}

- (AKTheme *)themeWithName:(NSString *)name {
    AKTheme *theme = [themesCache objectForKey:name];
    if (!theme) {
        theme = [AKTheme themeNamed:name withConfig:themeConfigs[name]];
        if (theme) [themesCache setObject:theme forKey:name];
    }
    return theme;
}

- (AKTheme *)objectForKeyedSubscript:(NSString *)name {
    return [self themeWithName:name];
}

- (void)setCurrentThemeName:(NSString *)name {
    currentThemeName = name;
    [[NSUserDefaults standardUserDefaults] setObject:currentThemeName forKey:AKThemeUDKey_CurrentThemeName];
}

- (AKTheme *)currentTheme {
    return [self themeWithName:currentThemeName];
}

@end
