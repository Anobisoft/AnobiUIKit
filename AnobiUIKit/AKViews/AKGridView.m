//
//  AKGridView.m
//  AnobiUIKit
//
//  Created by Stanislav Pletnev on 07.04.17.
//  Copyright © 2017 Anobisoft. All rights reserved.
//

#import "AKGridView.h"

@implementation AKGridView {
    CGFloat screenScale;
}

- (void)awakeFromNib {
    [super awakeFromNib];
#if !TARGET_INTERFACE_BUILDER
    screenScale = [UIScreen mainScreen].scale;
#endif
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
#if TARGET_INTERFACE_BUILDER
    screenScale = 2;
#endif
    
    if (self.tintColor && self.cellSize.width > self.lineWidth * 2 && self.cellSize.height > self.lineWidth * 2) {
        int m = (int)(self.bounds.size.width / self.cellSize.width);
        int n = (int)(self.bounds.size.height / self.cellSize.height);
        CGFloat xpad = (self.bounds.size.width - m * self.cellSize.width) / 2;
        CGFloat ypad = (self.bounds.size.height - n * self.cellSize.height) / 2;
        
        CGContextSetStrokeColorWithColor(context, self.tintColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth / screenScale);
        for (int i = 0; i <= m; i++) {
            CGFloat x = xpad + i * self.cellSize.width;
            CGContextMoveToPoint(context, x, 0.0);
            CGContextAddLineToPoint(context, x, self.bounds.size.height);
            CGContextStrokePath(context);
        }
        
        for (int i = 0; i <= n; i++) {
            CGFloat y = ypad + i * self.cellSize.height;
            CGContextMoveToPoint(context, 0.0, y);
            CGContextAddLineToPoint(context, self.bounds.size.width, y);
            CGContextStrokePath(context);
        }
    }
    
}

@end
