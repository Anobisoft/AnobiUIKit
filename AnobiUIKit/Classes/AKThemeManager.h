//
//  AKThemeManager.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 12.02.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import "AKTheme.h"

@interface AKThemeManager : NSObject

+ (instancetype)managerWithConfig:(NSDictionary *)config;
+ (instancetype)manager;

@property (nonatomic, readonly) NSArray<AKTheme *> *allThemes;
@property (nonatomic, readonly) NSArray<NSString *> *allNames;
@property (nonatomic) AKTheme *currentTheme;
- (AKTheme *)themeWithName:(NSString *)name;
- (AKTheme *)objectForKeyedSubscript:(NSString *)name;

@end
