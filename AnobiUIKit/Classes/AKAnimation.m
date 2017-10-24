//
//  AKAnimation.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 2017-01-13
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKAnimation.h"

#define AKAnimationDefaultDuration 0.6f

AK3DVector AK3DVectorMake(float x, float y, float z) {
	AK3DVector v;
	v.x = x;
	v.y = y;
	v.z = z;
	return v;
}

@implementation CAAnimation (AnobiAnimation)

+ (instancetype)flipWithPiCoef:(float)piCoef rotationVector:(AK3DVector)vector {
	return [self flipWithPiCoef:piCoef rotationVector:vector dutation:AKAnimationDefaultDuration];
}

+ (instancetype)flipWithPiCoef:(float)piCoef rotationVector:(AK3DVector)vector dutation:(CGFloat)duration {
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	NSMutableArray *mutableArray = [NSMutableArray new];
	NSUInteger framesCount = (NSUInteger)ceil(duration * 48.f);
	for (int i = 1; i <= framesCount; i++) {
		[mutableArray addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * piCoef * i / framesCount, vector.x, vector.y, vector.z)]];
	}
	animation.values = mutableArray.copy;
	animation.autoreverses = NO;
	animation.repeatCount = 1.0f;
	animation.duration = duration;
	return animation;
}

+ (instancetype)shakeAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = @[ [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)],
                          [NSValue valueWithCATransform3D:CATransform3DMakeTranslation( 5.0f, 0.0f, 0.0f)]
                          ];
    animation.autoreverses = YES;
    animation.repeatCount = 3.0f;
    animation.duration = 0.1f;
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
