//
//  MainViewModel.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/10.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "MainViewModel.h"
#import "NSArray+BB.h"

@implementation MainViewModel
-(instancetype)initWith:(NSArray *)info{
    
    if(info){
        self.errCode2 = [info toInt16:6];
        self.wangning2 = [info toInt16:8];
        self.sysStatus2 = [info toInt16:10];
        self.workmode2 = [info toInt16:12];
        self.ShengYuDianLiangBaiFenBi2 = [info toInt16:14];
        self.KMH2 = [info toInt16:16] > 20000 ? 0xffff - [info toInt16:16] : [info toInt16:16];
        self.PJSpeed1 = [info toInt16:18];
        self.KMTotal2 = [info toInt32:20];
        self.KMS = [info toInt16:24];
        self.SigRunTime2 = [info toInt16:26];
        self.Temperature2 = [info toInt16:28];
        self.SpeedLimitNow = [info toInt16:30];
        self.DianLiu2 = [info toInt16:32];
        self.MaxAbsKMH = [info toInt16:36];
        
    }
    return self;
}

-(void)setSysStatus2:(int)sysStatus2{
    _sysStatus2 = sysStatus2; 
    self.xiansu  = sysStatus2 & 0x0001 ;
    self.suoche = (sysStatus2 & 0x0002) >> 1;
    self.yaokong = (sysStatus2 & 0x0010) >> 4;
    self.zhanren = (sysStatus2 & 0x0400) >> 10;
    self.lingqi = (sysStatus2 & 0x4000) >> 14;
    
}
@end
