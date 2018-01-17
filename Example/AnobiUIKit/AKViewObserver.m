//
//  AKViewObserver.m
//  AnobiUIKit_Example
//
//  Created by Stanislav Pletnev on 17.01.2018.
//  Copyright © 2018 anobisoft. All rights reserved.
//

#import "AKViewObserver.h"

@implementation AKViewObserver

- (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController {
    if (self.callback) {
        UIColor *color = [UIColor colorWithHexString:self.callback()];
        viewController.view.backgroundColor = color;
    }
}

@end
