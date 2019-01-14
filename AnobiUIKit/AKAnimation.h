//
//  AKAnimation.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 2017-01-13
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat x;
    CGFloat y;
    CGFloat z;
} AK3DVector;

AK3DVector AK3DVectorMake(CGFloat x, CGFloat y, CGFloat z);
AK3DVector AK3DVectorReverse(AK3DVector vector);

extern CFTimeInterval const AKAnimationDefaultDuration;
extern double const AKAnimationDefaultFrameFrequency;

@interface CAAnimation (AnobiAnimation)

+ (instancetype)flipAngle:(CGFloat)rad vector:(AK3DVector)vector;
+ (instancetype)flipAngle:(CGFloat)rad vector:(AK3DVector)vector dutation:(CFTimeInterval)duration;
+ (instancetype)shakeVector:(AK3DVector)vector;
+ (instancetype)shakeVector:(AK3DVector)vector dutation:(CFTimeInterval)duration;

@end

@interface CALayer (AnobiAnimation)

- (void)addFlipAnimation:(CAAnimation *)animation;
- (void)addFlipAnimation:(CAAnimation *)animation withDuration:(NSTimeInterval)duration;

@end
