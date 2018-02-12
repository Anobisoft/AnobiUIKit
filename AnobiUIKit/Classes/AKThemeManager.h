//
//  AKThemeManager.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 12.02.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import <AnobiKit/AnobiKit.h>
#import "AKTheme.h"

@interface AKThemeManager : NSObject <DisableNSInit, KeyedSubscript>

+ (instancetype)managerWithConfigName:(NSString *)configName;
+ (instancetype)manager;

- (NSArray<NSString *> *)allNames;
- (AKTheme *)themeWithName:(NSString *)name;
@property NSUInteger cacheCostLimit;
@property (readonly) AKTheme *currentTheme;
- (void)setCurrentThemeName:(NSString *)name;



- (AKTheme *)objectForKeyedSubscript:(NSString *)name;

@end
