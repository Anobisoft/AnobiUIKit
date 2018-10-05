//
//  AKTheme.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 06.04.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKTheme.h"
#import "UIColor+Hex.h"

@interface AKTheme ()

@property (readonly) NSDictionary<NSString *, NSDictionary *> *appearanceSchema;

@end

@implementation AKTheme

+ (instancetype)themeNamed:(NSString *)name withConfig:(NSDictionary *)config {
    return [[self alloc] initWithName:name withConfig:config];
}

- (instancetype)initWithName:(NSString *)name withConfig:(NSDictionary *)config {
    if (self = [super init]) {
        if (![config isKindOfClass:NSDictionary.class]) {
            @throw [NSException exceptionWithName:@"AKThemeInvalidConfig" reason:@"theme config must be Dictionary type" userInfo:@{@"name" : name, @"config" : config}];
            return nil;
        }
        _name = name;
        
        NSDictionary<NSString *, NSString *> *keyedColorsRepresentation = config[AKThemeConfigKeyedColorsKey];
        NSMutableDictionary<NSString *, UIColor *> *keyedColorsM = [NSMutableDictionary new];
        for (NSString *key in keyedColorsRepresentation) {
            UIColor *color = [UIColor colorWithHexString:keyedColorsRepresentation[key]];
            if (color) keyedColorsM[key] = color;
        }
        _keyedColors = keyedColorsM.copy;
        
        NSArray<NSString *> *indexedColorsRepresentation = config[AKThemeConfigIndexedColorsKey];
        NSMutableArray<UIColor *> *indexedColorsM = [NSMutableArray new];
        for (NSString *colorHexRepresentation in indexedColorsRepresentation) {
            UIColor *color = [UIColor colorWithHexString:colorHexRepresentation];
            if (color) [indexedColorsM addObject:color];
        }
        _indexedColors = indexedColorsM.copy;
        
        _appearanceSchema = config[AKThemeConfigAppearanceSchemaKey];
        
        NSString *barStyleString = config[AKThemeConfigBarStyleKey];
        BOOL black = [barStyleString isEqualToString:@"Black"] || [barStyleString isEqualToString:@"Dark"];
        _barStyle = black ? UIBarStyleBlack : UIBarStyleDefault;
        _statusBarStyle = black ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
        
        if (!barStyleString && !_keyedColors.count && !_indexedColors.count) {
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
            NSArray *containedIn = obj[AKThemeConfigAppearanceContainedInInstancesOfClassesKey];
            id appearanceInstance;
            if (containedIn.count) {
                appearanceInstance = [viewClass appearanceWhenContainedInInstancesOfClasses:containedIn];
            } else {
                appearanceInstance = [viewClass appearance];
            }
            NSDictionary<NSString *, NSString *> *colorSchema = obj[AKThemeConfigAppearanceColorSchemaKey];
            [colorSchema enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull property, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                UIColor *color = [UIColor colorWithHexString:obj];
                NSString *firstSymbol = [property substringToIndex:1].uppercaseString;
                NSString *other = [property substringFromIndex:1];
                NSString *setter = [@[@"set", firstSymbol, other, @":"] componentsJoinedByString:@""];
                SEL selector = NSSelectorFromString(setter);
                NSMethodSignature *methodSignature = [appearanceInstance methodSignatureForSelector:selector];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
                invocation.target = appearanceInstance;
                invocation.selector = selector;
                [invocation setArgument:&color atIndex:2];
                [invocation invoke];
            }];
        }
    }];
    [self reloadAppearance];
}

- (void)reloadAppearance {
    NSArray * windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }
}

@end
