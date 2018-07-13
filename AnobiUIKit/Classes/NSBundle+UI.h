//
//  NSBundle+UI.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 14/07/2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

@interface NSBundle (UI)

+ (instancetype)UIBundle;
- (NSString *)localizedStringForKey:(NSString *)key;

NSString *UIBundleLocalizedString(NSString *key);

@end
