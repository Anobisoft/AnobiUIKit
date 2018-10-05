//
//  UIViewController+AK.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 16.02.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import "UIViewController+AK.h"
#import <AnobiKit/AnobiKit.h>

@implementation UIViewController (AK)

+ (UIImage *)imageNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[NSBundle bundleForClass:self] compatibleWithTraitCollection:nil];
}

- (UIImage *)imageNamed:(NSString *)name {
    return [self.class imageNamed:name];
}

+ (NSString *)localized:(NSString *)key {
    return [[NSBundle bundleForClass:self] localizedStringForKey:key];
}

- (NSString *)localized:(NSString *)key {
    return [self.class localized:key];
}

@end

