//
//  UIView+Autolayout.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 2016-10-04
//  Copyright © 2016 Anobisoft. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (Autolayout)

+ (instancetype)autolayoutView {
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
