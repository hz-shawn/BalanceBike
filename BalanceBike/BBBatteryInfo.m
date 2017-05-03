//
//  BBBatteryInfo.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/16.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBBatteryInfo.h"

@implementation BBBatteryInfo
-(instancetype)initWith:(NSArray *)info{
    if (info) {
        self.ShengYuDianLiang = [info toInt16:6];
        self.BaiFenBi = [info toInt16:8];
        self.DianLiu = [info toInt16:10];
      
        self.DianYa = [info toInt16:12];
        self.Temprer1 = [info[14] intValue];
        self.Temprer2 = [info[15] intValue];
    }
    
    return self;
}
@end
