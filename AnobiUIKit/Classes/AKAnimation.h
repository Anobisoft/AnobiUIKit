//
//  AKAnimation.h
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 2017-01-13
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    float x;
    float y;
    float z;
} AK3DVector;

AK3DVector AK3DVectorMake(float x, float y, float z);

@interface CAAnimation (AnobiAnimation)

+ (instancetype)flipWithPiCoef:(float)piCoef rotationVector:(AK3DVector)vector;
+ (instancetype)flipWithPiCoef:(float)piCoef rotationVector:(AK3DVector)vector dutation:(CGFloat)duration;
+ (instancetype)shakeAnimation;

@end


@interface CALayer (AnobiAnimation)

- (void)addFlipAnimation:(CAAnimation *)animation;
- (void)addFlipAnimation:(CAAnimation *)animation withDuration:(NSTimeInterval)duration;

@end
