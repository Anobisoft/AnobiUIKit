//
//  AKGrainbomatedView.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 30.08.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKGrainbomatedView.h"

@interface AKGrainbomatedView ()

@property CAGradientLayer *gradientLayer;

@end


@implementation AKGrainbomatedView {
	NSUInteger colorsCount;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)prepareForInterfaceBuilder {
    [self commonInit];
}

- (void)commonInit {
	NSArray *colors = @[(id)[UIColor colorWithRed:1 green:0.5 blue:0.5 alpha:1].CGColor,
						(id)[UIColor colorWithRed:1 green:1 blue:0 alpha:1].CGColor,
						(id)[UIColor colorWithRed:0.5 green:1 blue:0.5 alpha:1].CGColor,
						(id)[UIColor colorWithRed:0 green:1 blue:1 alpha:1].CGColor,
						(id)[UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1].CGColor,
						(id)[UIColor colorWithRed:1 green:0 blue:1 alpha:1].CGColor,
						(id)[UIColor colorWithRed:1 green:0.5 blue:0.5 alpha:1].CGColor,
						(id)[UIColor colorWithRed:1 green:1 blue:0 alpha:1].CGColor];
	
	colorsCount = colors.count;
	
    self.gradientLayer = [CAGradientLayer new];
    self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
	self.gradientLayer.endPoint = CGPointMake(1.0, 0.01);
    self.gradientLayer.colors = colors;
    [self.layer addSublayer:self.gradientLayer];
    
}

- (void)layoutSubviews {
	#if TARGET_INTERFACE_BUILDER
	self.gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width * (colorsCount - 1) / (colorsCount - 2), self.bounds.size.height);
	#else
	self.gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width * (colorsCount - 1), self.bounds.size.height);
    
    [self.gradientLayer removeAnimationForKey:@"gradientAnimation"];
    CABasicAnimation *gradientAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    gradientAnimation.duration = 5.0;
    gradientAnimation.byValue  = @(-1 / [UIScreen mainScreen].scale);
    gradientAnimation.repeatCount = INFINITY;
    
	gradientAnimation.toValue   = @(self.gradientLayer.position.x);
	gradientAnimation.fromValue = @(self.gradientLayer.position.x - self.bounds.size.width * (colorsCount - 2));
    [self.gradientLayer addAnimation:gradientAnimation forKey:@"gradientAnimation"];
    #endif
    [super layoutSubviews];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self.gradientLayer removeAnimationForKey:@"gradientAnimation"];
}

@end
