//
//  AKGrainbomatedView.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 30.08.17.
//  Copyright © 2017 anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface AKGrainbomatedView : UIView

@property (nonatomic) IBInspectable CGFloat blickWidth;
@property (nonatomic) IBInspectable CGFloat blickDuration;
@property IBInspectable BOOL vertical;

@end
