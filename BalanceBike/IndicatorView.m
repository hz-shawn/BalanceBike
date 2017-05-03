//
//  IndicatorView.m
//  BezierTest
//
//  Created by zemadr3 on 2017/3/22.
//  Copyright © 2017年 zemadr. All rights reserved.
//

#import "IndicatorView.h"
@interface IndicatorView ()

@property (weak,nonatomic)  CAShapeLayer *shapeLayer;
@end
@implementation IndicatorView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        UIBezierPath *polygon = [UIBezierPath bezierPath];
        
        [polygon moveToPoint:CGPointMake(width - 20, frame.size.height * 0.5)];
        [polygon addLineToPoint:CGPointMake(width, 0)];
        [polygon addLineToPoint:CGPointMake(width, height)];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.lineWidth = 5.0f;
        shapeLayer.fillColor = [UIColor redColor].CGColor; 
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
