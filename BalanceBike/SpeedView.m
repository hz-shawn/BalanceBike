//
//  SpeedView.m
//  BezierTest
//
//  Created by zemadr3 on 2017/3/21.
//  Copyright © 2017年 zemadr. All rights reserved.
//

#import "SpeedView.h"
@interface SpeedView ()

@property (nonatomic,strong) NSMutableArray * paths;
@property (weak,nonatomic) CAShapeLayer *powerLayer;
@property (weak,nonatomic) UILabel *powerLabel;
@property (weak,nonatomic) UILabel *speedLabel;
@property (weak,nonatomic) UILabel *totalKMLabel;
@property (weak,nonatomic) UILabel *danweiLabel;

@end

@implementation SpeedView



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        CGPoint center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
        CGFloat radius = frame.size.width * 0.5;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI - M_PI/4 endAngle:-M_PI - M_PI/4 - M_PI/2 clockwise:NO];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        self.powerLayer  = shapeLayer;
        shapeLayer.lineWidth = 10.0f;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor colorWithRed:0 green:225/255.0 blue:218/255.0 alpha:1.0].CGColor;
        shapeLayer.path = path.CGPath;
        shapeLayer.lineCap = @"round";
        [self.layer addSublayer:shapeLayer];
        
        
        CGFloat perAngle = (M_PI+ M_PI/3 )/ 50;
        //我们需要计算出每段弧线的起始角度和结束角度
        //这里我们从- M_PI 开始，我们需要理解与明白的是我们画的弧线与内侧弧线是同一个圆心
        for (int i = 0; i< 50; i++) {
            
            CGFloat startAngel = (-M_PI - M_PI/6 + perAngle * i);
            CGFloat endAngel   = startAngel + perAngle/4;
            
            UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngel endAngle:endAngel clockwise:YES];
            CAShapeLayer *perLayer = [CAShapeLayer layer];
            
            perLayer.strokeColor = [UIColor whiteColor].CGColor;
            perLayer.lineWidth   = 10;
            
            perLayer.path = tickPath.CGPath;
            
            [self.layer addSublayer:perLayer];
        }
        
        
        //我们需要计算出每段弧线的起始角度和结束角度
        //这里我们从- M_PI 开始，我们需要理解与明白的是我们画的弧线与内侧弧线是同一个圆心
        for (int i = 0; i< 50; i++) {
            
            CGFloat startAngel = (-M_PI - M_PI/6 + perAngle * i);
            CGFloat endAngel   = startAngel + perAngle/4;
            
            UIBezierPath *tickPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngel endAngle:endAngel clockwise:YES];
            CAShapeLayer *perLayer = [CAShapeLayer layer];
            perLayer.strokeColor = [UIColor colorWithRed:0.22 green:0.66 blue:0.87 alpha:1.0].CGColor;
            perLayer.lineWidth   = 10;
            [self.paths addObject:perLayer];
            perLayer.path = tickPath.CGPath;
            [self.layer addSublayer:perLayer];
        }
        
        //设置电量的显示
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor =  [UIColor colorWithRed:0 green:219/255.0 blue:209/255.0 alpha:1.0];
        label.center = CGPointMake(frame.size.width * 0.5, frame.size.height - 25);
        [self addSubview:label];
        self.powerLabel = label;
        self.powerLabel.text = @"100%";
        
        UILabel *kmLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        
        kmLabel.text = @"km/h";
        kmLabel.font = [UIFont systemFontOfSize:12];
        kmLabel.textAlignment = NSTextAlignmentCenter;
        kmLabel.textColor = [UIColor whiteColor];
        kmLabel.center = CGPointMake(frame.size.width * 0.5, 40);
        [self addSubview:kmLabel];
        self.danweiLabel = kmLabel;
        
        UILabel *speedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 80)];
        speedLabel.font =  [UIFont fontWithName:@"Block Condensed" size:60];
        speedLabel.text = @"0.0";
        speedLabel.textAlignment = NSTextAlignmentCenter;
        speedLabel.textColor = [UIColor whiteColor];
        speedLabel.center = CGPointMake(frame.size.width * 0.5,80);
        self.speedLabel = speedLabel;
        [self addSubview:speedLabel];
        
        
        UILabel *totalKM = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-60, 30)];
        totalKM.text = @"限速 4.0";
        totalKM.font = [UIFont systemFontOfSize:12];
        totalKM.textAlignment = NSTextAlignmentCenter;
        totalKM.textColor = [UIColor whiteColor];
        totalKM.center = CGPointMake(frame.size.width * 0.5,130);
        totalKM.layer.borderWidth = 1.0f;
        totalKM.layer.cornerRadius = 12.0f;
        totalKM.layer.borderColor = [UIColor whiteColor].CGColor;
        totalKM.layer.masksToBounds = YES;
        self.totalKMLabel = totalKM;
        [self addSubview:totalKM];
        
    }
    return self;
}


-(NSMutableArray *)paths{
    if (!_paths) {
        _paths = [NSMutableArray arrayWithCapacity:10];
    }
    return _paths;
}


-(void)setSpeed:(CGFloat)speed{
    _speed = speed;
    int index = (_speed / self.maxSpeed) * 50;
    self.speedLabel.text = [NSString stringWithFormat:@"%.1f",speed];
    
    for (int i = 0; i < 50; i++) {
        CAShapeLayer *layer = self.paths[i];
        layer.hidden = i >= index;
    }
}


-(void)setPower:(CGFloat)power{
    _power = power;
    self.powerLayer.strokeEnd = _power;
    self.powerLabel.text = [NSString stringWithFormat:@"%d%%", (int)(_power*100)];
    if (isMi) {
        self.danweiLabel.text = @"mph";
    }else{
        self.danweiLabel.text = @"Km/h";
    }
}

-(void)setTotalKm:(CGFloat)totalKm{
    _totalKm = totalKm;
    if (isMi) {
         self.totalKMLabel.text = [NSString stringWithFormat:@"限速 %.1f ",toMi(totalKm)];
    }else{
         self.totalKMLabel.text = [NSString stringWithFormat:@"限速 %.1f ",totalKm];
    }
  
}
@end
