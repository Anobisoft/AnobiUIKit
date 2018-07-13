//
//  NSBundle+UI.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 14/07/2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import "NSBundle+UI.h"

@implementation NSBundle (UI)

+ (instancetype)UIBundle {
    return [self bundleForClass:UIApplication.class];
}

- (NSString *)localizedStringForKey:(NSString *)key {
    return [self localizedStringForKey:key value:nil table:nil];
}

NSString *UIBundleLocalizedString(NSString *key) {
    return [[NSBundle UIBundle] localizedStringForKey:key];
}

@end
