//
//  UIView+AnobiUIKit.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 2016-10-04
//  Copyright © 2016 Anobisoft. All rights reserved.
//

#import "UIView+AnobiUIKit.h"

@implementation UIView (AnobiUIKit)

+ (instancetype)autolayoutView {
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
