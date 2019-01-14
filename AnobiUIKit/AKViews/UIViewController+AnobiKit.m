//
//  UIViewController+AnobiKit.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 16.02.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import "UIViewController+AnobiKit.h"

@implementation UIViewController (AnobiKit)

+ (UIImage *)imageNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[NSBundle bundleForClass:self] compatibleWithTraitCollection:nil];
}

- (UIImage *)imageNamed:(NSString *)name {
    return [self.class imageNamed:name];
}

+ (NSString *)localized:(NSString *)key {
    return [[NSBundle bundleForClass:self] localizedStringForKey:key value:nil table:nil];
}

- (NSString *)localized:(NSString *)key {
    return [self.class localized:key];
}

@end
