//
//  UIViewController+AK.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 16.02.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (AK)

+ (UIImage *)imageNamed:(NSString *)name;
- (UIImage *)imageNamed:(NSString *)name;
+ (NSString *)localized:(NSString *)key;
- (NSString *)localized:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

