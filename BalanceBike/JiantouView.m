//
//  JiantouView.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/4/23.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "JiantouView.h"
@interface JiantouView ()

@property (weak,nonatomic)  CAShapeLayer *shapeLayer;
@end
@implementation JiantouView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        UIBezierPath *polygon = [UIBezierPath bezierPath];
        
        [polygon moveToPoint:CGPointMake(width + 20, frame.size.height * 0.5)];
        [polygon addLineToPoint:CGPointMake(width, 0)];
        [polygon addLineToPoint:CGPointMake(width, height)];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.lineWidth = 5.0f;
        shapeLayer.fillColor = [UIColor colorWithHex:0x00f0ff].CGColor;
        shapeLayer.path = polygon.CGPath;
        [self.layer addSublayer:shapeLayer];
        self.shapeLayer = shapeLayer;
    }
    return self;
}


-(void)setColor:(UIColor *)color{
    _color = color;
    if (color) {
        self.shapeLayer.fillColor = color.CGColor;
    }
}

@end
