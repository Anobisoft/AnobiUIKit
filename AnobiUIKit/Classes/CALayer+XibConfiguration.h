//
//  CALayer+XibConfiguration.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 24.10.2017.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (XibConfiguration)
// This assigns a CGColor to borderColor.
@property(nonatomic, assign) UIColor* borderUIColor;

@end
