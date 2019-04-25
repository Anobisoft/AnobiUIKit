//
//  AKTheme.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 06.04.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKTheme.h"
#import <AnobiKit/UIColor+Hex.h>
#import <AnobiKit/AKStrings.h>

@interface NSObject (UIAppearance)

- (void)setColor:(UIColor *)color forProperty:(NSString *)property;

@end

@implementation NSObject (UIAppearance)

- (void)setColor:(UIColor *)color forProperty:(NSString *)property {
    NSString *firstSymbol = [property substringToIndex:1].uppercaseString;
    NSString *other = [property substringFromIndex:1];
    NSString *setter = [@"set" : firstSymbol : other : @":"];
    SEL selector = NSSelectorFromString(setter);
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.target = self;
    invocation.selector = selector;
    [invocation setArgument:&color atIndex:2];
    [invocation invoke];
}

@end

#pragma mark -

@interface AKTheme ()

@property (readonly) NSDictionary<NSString *, NSDictionary *> *appearanceSchema __WATCHOS_UNAVAILABLE;

@end

@implementation AKTheme

+ (instancetype)themeNamed:(NSString *)name withConfig:(NSDictionary *)config {
    if (![config isKindOfClass:NSDictionary.class]) {
        @throw [NSException exceptionWithName:@"AKThemeInvalidConfig" reason:@"theme config must be Dictionary type" userInfo:@{@"name" : name, @"config" : config}];
        return nil;
    }
    return [[self alloc] initWithName:name withConfig:config];
}

- (NSArray<UIColor *> *)colorsWithHexStrings:(NSArray<NSString *> *)hexStrings {
    NSMutableArray<UIColor *> *colors = [NSMutableArray new];
    for (NSString *hexColor in hexStrings) {
        UIColor *color = [UIColor colorWithHexString:hexColor];
        if (color) [colors addObject:color];
    }
    return colors.copy;
}

- (instancetype)initWithName:(NSString *)name withConfig:(NSDictionary *)config {
    if (self = [super init]) {

        _name = name;
        
        NSDictionary<NSString *, NSString *> *keyedColorsRepresentation = config[AKThemeConfigKeyedColorsKey];
        NSMutableDictionary<NSString *, UIColor *> *keyedColorsM = [NSMutableDictionary new];
        NSMutableDictionary<NSString *, NSArray<UIColor *> *> *keyedColorCollectionsM = [NSMutableDictionary new];
        for (NSString *key in keyedColorsRepresentation) {
            id value = keyedColorsRepresentation[key];
            if ([value isKindOfClass:NSString.class]) {
                UIColor *color = [UIColor colorWithHexString:value];
                if (color) keyedColorsM[key] = color;
            } else if ([value isKindOfClass:NSArray.class]) {
                keyedColorCollectionsM[key] = [self colorsWithHexStrings:value];
            } else {
                @throw NSInvalidArgumentException;
            }
        }
        _keyedColors = keyedColorsM.copy;
        _keyedColorCollections = keyedColorCollectionsM.copy;
        
        NSArray<NSString *> *indexedColorsRepresentation = config[AKThemeConfigIndexedColorsKey];
        _indexedColors = [self colorsWithHexStrings:indexedColorsRepresentation];
        
        NSString *barStyleString = config[AKThemeConfigStatusBarStyleKey];
        BOOL black = [barStyleString isEqualToString:@"Black"] || [barStyleString isEqualToString:@"Dark"];
        _statusBarStyle = black ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
        
        _appearanceSchema = config[AKThemeConfigAppearanceSchemaKey];
        
        if (!_keyedColors.count && !_indexedColors.count && !barStyleString && !_appearanceSchema) {
            @throw [NSException exceptionWithName:@"AKThemeEmptyConfig" reason:@"theme config is empty" userInfo:@{@"name" : name, @"config" : config}];
            return nil;
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

- (void)applyAppearanceSchema {
    Protocol *appearanceProtocol = @protocol(UIAppearance);
    [self.appearanceSchema enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
        Class<UIAppearance> viewClass = NSClassFromString(key);
        if ([viewClass conformsToProtocol:appearanceProtocol]) {
            [self resetAppearanceConfig:obj forClass:viewClass];
        }
    }];
    
    UINavigationBar.appearance.barStyle = (UIBarStyle)self.statusBarStyle;
    
    [self reloadAppearance];
}

- (void)resetAppearanceConfig:(NSDictionary *)config forClass:(Class<UIAppearance>)viewClass {
    NSArray *containedIn = config[AKThemeConfigAppearanceContainedInInstancesOfClassesKey];
    id appearanceInstance;
    if (containedIn.count) {
        appearanceInstance = [viewClass appearanceWhenContainedInInstancesOfClasses:containedIn];
    } else {
        appearanceInstance = [viewClass appearance];
    }
    NSDictionary<NSString *, NSString *> *colorSchema = config[AKThemeConfigAppearanceColorSchemaKey];
    [colorSchema enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull property, NSString * _Nonnull hexColor, BOOL * _Nonnull stop) {
        UIColor *color = [UIColor colorWithHexString:hexColor];
        [appearanceInstance setColor:color forProperty:property];
    }];
}

- (void)reloadAppearance {
    NSArray *windows = UIApplication.sharedApplication.windows;
    for (UIWindow *window in windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }
}

@end


