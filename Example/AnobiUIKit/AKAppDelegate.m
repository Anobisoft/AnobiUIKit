//
//  AKAppDelegate.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 08/02/2017.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKAppDelegate.h"
#import <AnobiKit/AnobiKit.h>
#import <AnobiUIKit/AnobiUIKit.h>
#import "AKMainViewController.h"
#import "AKViewObserver.h"

@implementation AKAppDelegate {
    __strong AKViewObserver *observer;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"%@", [NSBundle UIKitBundle].localizationTable.allKeys);
    
    [AKGradientView appearance].startPoint = CGPointMake(0, 0);
    [AKGradientView appearance].endPoint = CGPointMake(1, 1);
    
    UIButton *button = [UIButton appearance];
    button.tintColor = [UIColor greenColor];
    
    observer = [AKViewObserver observerForClass:NSClassFromString(@"AKMainViewController")];
    static int i = 0;
    NSArray *colors = @[@"#FF0055", @"#33FF55", @"#0022FF"];
    observer.callback = ^NSString *{
        if (i == colors.count) {
            self->observer = nil;
        }
        return colors[i++%colors.count];
    };
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
