//
//  AKTheme.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 06.04.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+AK.h"

#define AKThemeConfigKey_KeyedColors @"KeyedColors"
#define AKThemeConfigKey_IndexedColors @"IndexedColors"
#define AKThemeConfigKey_BarStyle @"BarStyle"

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

#define AKThemeColorKey_mainBackground @"mainBackground"
#define AKThemeColorKey_mainTint @"mainTint"
#define AKThemeColorKey_mainText @"mainText"
#define AKThemeColorKey_mainSubtext @"mainSubtext"
#define AKThemeColorKey_mainTitle @"mainTitle"
#define AKThemeColorKey_mainSubtitle @"mainSubtitle"


#define AKThemeColorKey_tableTint @"tableTint"
#define AKThemeColorKey_tableText @"tableText"
#define AKThemeColorKey_tableTitle @"tableTitle"
#define AKThemeColorKey_tableSubtitle @"tableSubtitle"
#define AKThemeColorKey_tableSeparator @"tableSeparator"
#define AKThemeColorKey_tableBackground @"tableBackground"
#define AKThemeColorKey_tableSectionHeaderBackground @"tableSectionHeaderBackground"
#define AKThemeColorKey_tableCellBackground @"tableCellBackground"
#define AKThemeColorKey_tableSelectedCellBackground @"tableSelectedCellBackground"
#define AKThemeColorKey_tableSecondaryCellBackground @"tableSecondaryCellBackground"
#define AKThemeColorKey_tableCellTint @"tableInactiveCellTint"
#define AKThemeColorKey_tableInactiveCellTint @"tableInactiveCellTint"


#define AKThemeColorKey_naviBarTint @"naviBarTint"
#define AKThemeColorKey_naviTint @"naviTint"
#define AKThemeColorKey_naviTitle @"naviTitle"
#define AKThemeColorKey_naviBackground @"naviBackground"


#define AKThemeColorKey_toolBarTint @"toolBarTint"
#define AKThemeColorKey_toolTint @"toolTint"
#define AKThemeColorKey_toolBackground @"toolBackground"
#define AKThemeColorKey_toolPositive @"toolPositive"
#define AKThemeColorKey_toolNegative @"toolNegative"
#define AKThemeColorKey_toolPositiveTint @"toolPositiveTint"
#define AKThemeColorKey_toolNegativeTint @"toolNegativeTint"


#define AKThemeColorKey_searchbar @"searchbar"
#define AKThemeColorKey_searchbarTint @"searchbarTint"
