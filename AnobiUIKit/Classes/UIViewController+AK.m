//
//  UIViewController+AK.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 16.02.2018.
//  Copyright © 2016 Anobisoft. All rights reserved.
//

#import "UIViewController+AK.h"

@implementation UIViewController (AK)

+ (UIImage *)imageNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[NSBundle bundleForClass:self] compatibleWithTraitCollection:nil];
}

- (UIImage *)imageNamed:(NSString *)name {
    return [self.class imageNamed:name];
}

@end
