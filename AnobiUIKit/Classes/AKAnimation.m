//
//  AKAnimation.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 2017-01-13
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKAnimation.h"

AK3DVector AK3DVectorMake(CGFloat x, CGFloat y, CGFloat z) {
	AK3DVector v;
	v.x = x;
	v.y = y;
	v.z = z;
	return v;
}

AK3DVector AK3DVectorReverse(AK3DVector vector) {
    AK3DVector v;
    v.x = -1.0 * vector.x;
    v.y = -1.0 * vector.y;
    v.z = -1.0 * vector.z;
    return v;
}

CFTimeInterval const AKAnimationDefaultDuration = 0.6;
double const AKAnimationDefaultFrameFrequency = 48;

@implementation CAAnimation (AnobiAnimation)

NSUInteger AKFrameCount(CFTimeInterval duration, double frameFrequency) {
    return ceil(duration * frameFrequency);
}

+ (instancetype)flipAngle:(CGFloat)rad vector:(AK3DVector)vector {
    return [self flipAngle:rad vector:vector dutation:AKAnimationDefaultDuration];
}

+ (instancetype)flipAngle:(CGFloat)rad vector:(AK3DVector)vector dutation:(CFTimeInterval)duration {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *mutableArray = [NSMutableArray new];
    NSUInteger frameCount = AKFrameCount(duration, AKAnimationDefaultFrameFrequency);
    for (int i = 1; i <= frameCount; i++) {
        [mutableArray addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(rad * i / frameCount, vector.x, vector.y, vector.z)]];
    }
    animation.values = mutableArray.copy;
    animation.autoreverses = false;
    animation.repeatCount = 1.0f;
    animation.duration = duration;
    return animation;
}

+ (instancetype)shakeVector:(AK3DVector)vector {
    return [self shakeVector:vector dutation:AKAnimationDefaultDuration * 2.0];
}

+ (instancetype)shakeVector:(AK3DVector)vector dutation:(CFTimeInterval)duration {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    AK3DVector reverseVector = AK3DVectorReverse(vector);
    animation.values = @[ [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(vector.x, vector.y, vector.z)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(reverseVector.x, reverseVector.y, reverseVector.z)]
                          ];
    animation.autoreverses = true;
    animation.repeatCount = 3.0f;
    animation.duration = duration;
    return animation;
}

@end

@implementation CALayer(AnobiAnimation)

- (void)addFlipAnimation:(CAAnimation *)anim {
    self.zPosition = MAX(self.bounds.size.width, self.bounds.size.height) / 2 + 1;
    [self addAnimation:anim forKey:nil];
}

- (void)addFlipAnimation:(CAAnimation *)anim withDuration:(NSTimeInterval)duration {
    anim.duration = duration;
    [self addFlipAnimation:anim];
}

@end
