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
@property CAShapeLayer *paraLayer;
@property CAShapeLayer *echoparaLayer;
@end

@implementation AKGrainbomatedView {
    CABasicAnimation *gradientAnimation;
    CABasicAnimation *paraLayerAnimation;
    CGFloat cathetus;
	NSUInteger colorsCount;
}

static CGFloat atanPI8;
+ (void)initialize {
    [super initialize];
    atanPI8 = atan(M_PI_4 * 0.7);
	
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
    [self restartAnimation];    
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
    [self.layer addSublayer:self.gradientLayer];
    self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
	self.gradientLayer.endPoint = self.vertical ? CGPointMake(0.01, 1.00) : CGPointMake(1.0, 0.01);
    self.gradientLayer.colors = colors;
    
	gradientAnimation = [CABasicAnimation animationWithKeyPath:self.vertical ? @"position.y" : @"position.x"];
    gradientAnimation.duration = 5.0;
    gradientAnimation.byValue  = @(-1 / [UIScreen mainScreen].scale);
    gradientAnimation.repeatCount = INFINITY;
    
    
    self.paraLayer = [CAShapeLayer new];
    [self.layer addSublayer:self.paraLayer];
    self.echoparaLayer = [CAShapeLayer new];
    [self.layer addSublayer:self.echoparaLayer];
    
    self.echoparaLayer.fillColor = self.paraLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
    paraLayerAnimation = [CABasicAnimation animationWithKeyPath:self.vertical ? @"position.y" : @"position.x"];
    
    paraLayerAnimation.duration = self.blickDuration ?: 1.2;
    paraLayerAnimation.repeatCount = 1;
    paraLayerAnimation.removedOnCompletion = YES;
}

- (void)layoutSubviews {
	#if TARGET_INTERFACE_BUILDER
	self.gradientLayer.frame = self.vertical
		? CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height * (colorsCount - 1) / (colorsCount - 2))
		: CGRectMake(0, 0, self.bounds.size.width * (colorsCount - 1) / (colorsCount - 2), self.bounds.size.height);
	#else
	self.gradientLayer.frame = self.vertical
		? CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height * (colorsCount - 1))
		: CGRectMake(0, 0, self.bounds.size.width * (colorsCount - 1), self.bounds.size.height);
	gradientAnimation.toValue   = self.vertical ? @(self.gradientLayer.position.y) : @(self.gradientLayer.position.x);
	gradientAnimation.fromValue = self.vertical
		? @(self.gradientLayer.position.y - self.bounds.size.height * (colorsCount - 2))
		: @(self.gradientLayer.position.x - self.bounds.size.width * (colorsCount - 2));
    [self.gradientLayer removeAnimationForKey:@"gradientAnimation"];
    [self.gradientLayer addAnimation:gradientAnimation forKey:@"gradientAnimation"];
    #endif
    
    [self redrawParaLayers];
    [super layoutSubviews];
}

@synthesize blickDuration = _blickDuration;
- (void)setBlickDuration:(CGFloat)blickDuration {
    _blickDuration = blickDuration >= 0.3 ? blickDuration : 1.2;
    if (paraLayerAnimation) paraLayerAnimation.duration = _blickDuration;
}

@synthesize blickWidth = _blickWidth;
- (void)setBlickWidth:(CGFloat)blickWidth {
    _blickWidth = blickWidth;
    [self redrawParaLayers];
}

- (void)redrawParaLayers {
	cathetus = (self.vertical ? self.bounds.size.width : self.bounds.size.height) * atanPI8;
    if (self.blickWidth < 8) {
		_blickWidth = (self.vertical ? self.bounds.size.height : self.bounds.size.width) * 0.05;
    }
    
#if TARGET_INTERFACE_BUILDER
    CGFloat start =  10;
#else
    CGFloat start =  - cathetus - self.blickWidth;
#endif
	
	
	CGPoint p1, p2, p3, p4;
	p1 = self.vertical ? CGPointMake(self.frame.size.width, start) : CGPointMake(start, self.frame.size.height);
	p2 = self.vertical ? CGPointMake(0, start + cathetus) : CGPointMake(start + cathetus, 0);
	p3 = self.vertical ? CGPointMake(0, start + cathetus + self.blickWidth * 0.5) : CGPointMake(start + cathetus + self.blickWidth * 0.5, 0);
	p4 = self.vertical ? CGPointMake(self.frame.size.width, start + self.blickWidth * 0.5) : CGPointMake(start + self.blickWidth * 0.5, self.frame.size.height);
	UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
    [path addLineToPoint:p4];
    [path closePath];
    self.paraLayer.path = path.CGPath;
	
	p1 = self.vertical ? CGPointMake(self.frame.size.width, start + self.blickWidth * 0.625) : CGPointMake(start + self.blickWidth * 0.625, self.frame.size.height);
	p2 = self.vertical ? CGPointMake(0, start + self.blickWidth * 0.625 + cathetus) : CGPointMake(start + self.blickWidth * 0.625 + cathetus, 0);
	p3 = self.vertical ? CGPointMake(0, start + self.blickWidth * 0.625 + cathetus + self.blickWidth * 0.15) : CGPointMake(start + self.blickWidth * 0.625 + cathetus + self.blickWidth * 0.15, 0);
	p4 = self.vertical ? CGPointMake(self.frame.size.width, start + self.blickWidth * 0.625 + self.blickWidth * 0.15) : CGPointMake(start + self.blickWidth * 0.625 + self.blickWidth * 0.15, self.frame.size.height);
    path = [UIBezierPath bezierPath];
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
    [path addLineToPoint:p4];
    [path closePath];
    self.echoparaLayer.path = path.CGPath;
}

- (void)restartAnimation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(((float)rand() / RAND_MAX + 0.5) * 3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat sh = cathetus + self.blickWidth;
		CGFloat fv, tv;
		fv = self.vertical ? self.paraLayer.position.y : self.paraLayer.position.x;
		tv = self.vertical ? self.paraLayer.position.y + self.bounds.size.height : self.paraLayer.position.x + self.bounds.size.width;
		paraLayerAnimation.fromValue = @(fv - sh);
		paraLayerAnimation.toValue   = @(tv + sh);
        [self.paraLayer removeAnimationForKey:@"paraLayerAnimation"];
        [self.paraLayer addAnimation:paraLayerAnimation forKey:@"paraLayerAnimation"];
		
		fv = self.vertical ? self.echoparaLayer.position.y : self.echoparaLayer.position.x;
		tv = self.vertical ? self.echoparaLayer.position.y + self.bounds.size.height : self.echoparaLayer.position.x + self.bounds.size.width;
		paraLayerAnimation.fromValue = @(fv - sh);
		paraLayerAnimation.toValue   = @(tv + sh);
		[self.echoparaLayer removeAnimationForKey:@"paraLayerAnimation"];
        [self.echoparaLayer addAnimation:paraLayerAnimation forKey:@"paraLayerAnimation"];
        [self restartAnimation];
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
