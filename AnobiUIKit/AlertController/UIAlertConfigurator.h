//
//  UIAlertConfigurator.h
//  AnobiKit
//
//  Created by Stanislav Pletnev on 11/01/2019.
//  Copyright © 2019 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UIAlertConfigurator <NSObject>
@optional
- (UIAlertControllerStyle)alertControllerPreferredStyle;
- (UIView *)alertControllerPresentationSourceView;
- (CGRect)alertControllerPresentationSourceRect;
- (UIPopoverArrowDirection)alertControllerPresentationPermittedArrowDirections;

@end

NS_ASSUME_NONNULL_END
