//
//  AKAppDelegate.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 08/02/2017.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKAppDelegate.h"

#import <AnobiKit/AnobiKit.h>
#import <AnobiKit/UIColor+Hex.h>
#import <AnobiUIKit/AnobiUIKit.h>
#import <AnobiView/AnobiView.h>

#import "AKMainViewController.h"


@implementation UIMainView
@end

@interface AKAppDelegate () <AKViewObserver>

@end

@implementation AKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"%@", [[NSBundle UIKitBundle].localizationTable.allKeys subarrayWithRange:NSMakeRange(0, 10)]);
    
    [ASGradientView appearance].startPoint = CGPointMake(0, 0);
    [ASGradientView appearance].endPoint = CGPointMake(1, 1);
    
    [AKViewDispatcher addViewObserver:self forClass:AKMainViewController.class];
    
    return YES;
}

- (void)viewWillAppear:(BOOL)animated viewController:(UIViewController *)viewController {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    static int i = 0;
    static NSArray *colors = nil;
    if (!colors) {
        colors = @[UIColorWithHexRGB(0xFF0055, 1),
                   UIColorWithHexRGB(0x33FF55, 1),
                   UIColorWithHexRGB(0x0022FF, 1)];
    }
    for (UIView *view in viewController.view.subviews) {
        if ([view isKindOfClass:UITableView.class]) {
            view.backgroundColor = colors[i++%colors.count];
        }
    }
}

@end
