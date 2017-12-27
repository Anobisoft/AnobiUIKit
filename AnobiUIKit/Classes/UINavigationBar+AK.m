//
//  UINavigationBar+AK.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 27.12.2017.
//

#import "UINavigationBar+AK.h"

@implementation UINavigationBar (AK)

- (UIColor *)titleTextColor {
    return self.titleTextAttributes[NSForegroundColorAttributeName];
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    NSMutableDictionary *titleTextAttributes = self.titleTextAttributes.mutableCopy;
    if (!titleTextAttributes) {
        titleTextAttributes = [NSMutableDictionary new];
    }
    titleTextAttributes[NSForegroundColorAttributeName] = titleTextColor;
    self.titleTextAttributes = titleTextAttributes;
}



@end
