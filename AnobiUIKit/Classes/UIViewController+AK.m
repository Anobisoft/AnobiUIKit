//
//  UIViewController+AK.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 16.02.2018.
//  Copyright © 2016 Anobisoft. All rights reserved.
//

#import "UIViewController+AK.h"

@implementation UIViewController (AK)

- (UIImage *)imageNamed:(NSString *)imnm {
    return [UIImage imageNamed:imnm inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
}

@end
