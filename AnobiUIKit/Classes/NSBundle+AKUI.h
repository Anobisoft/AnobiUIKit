//
//  NSBundle+AKUI.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 14/07/2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

@interface NSBundle (AKUI)

+ (instancetype)UIBundle;
- (NSString *)localizedStringForKey:(NSString *)key;

NSString *UIBundleLocalizedString(NSString *key);

@end
