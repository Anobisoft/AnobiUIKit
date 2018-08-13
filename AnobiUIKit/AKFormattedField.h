//
//  AKFormattedField.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 06.01.2018.
//  Copyright © 2018 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKFormattedField : UITextField
@property (nonatomic) IBInspectable NSString *format;
@property (nonatomic) IBInspectable NSString *pattern;
@property (readonly) NSString *formattedText;
@end
