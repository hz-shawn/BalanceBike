
//
//  LimitSpeedModel.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/15.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "LimitSpeedModel.h"

@implementation LimitSpeedModel
-(instancetype)initWith:(NSArray *)info{
    if (info) { 
        self.XianSuSet = [info toInt16:8];
    }
    
    return self;
}
@end
