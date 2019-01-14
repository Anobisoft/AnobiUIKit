//
//  AKViewObserver.m
//  AnobiUIKit_Example
//
//  Created by Stanislav Pletnev on 17.01.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import "AKViewObserver.h"
#import <AnobiKit/UIColor+Hex.h>

@implementation AKViewObserver

- (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.callback) {
        UIColor *color = [UIColor colorWithHexString:self.callback()];
        viewController.view.backgroundColor = color;
    }
}

@end
