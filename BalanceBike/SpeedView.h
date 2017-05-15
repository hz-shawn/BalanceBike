//
//  SpeedView.h
//  BezierTest
//
//  Created by zemadr3 on 2017/3/21.
//  Copyright © 2017年 zemadr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeedView : UIView

@property (assign,nonatomic) CGFloat speed;
@property (assign,nonatomic) CGFloat maxSpeed;

@property (assign,nonatomic) CGFloat power;
@property (assign,nonatomic) CGFloat totalKm;//限速
@end
