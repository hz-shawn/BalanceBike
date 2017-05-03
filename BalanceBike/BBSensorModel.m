//
//  BBSensorModel.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/16.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBSensorModel.h"

@implementation BBSensorModel
-(instancetype)initWith:(NSArray *)info{
    if (info) {
        self.ShouBaLingMingDu = [info toInt16:6];
        self.QiXingLingMinDu = [info toInt16:8];
        self.ZhuLiPhengDian = [info toInt16:10];
    }
    
    return self;
}
@end
