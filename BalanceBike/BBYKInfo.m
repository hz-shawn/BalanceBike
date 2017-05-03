//
//  BBYKInfo.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/31.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBYKInfo.h"

@implementation BBYKInfo
-(instancetype)initWith:(NSArray *)info{
    if (info) {
        if (info) {
            self.sysStatus2 = [info toInt16:6];
            self.workmode2 = [info toInt16:8];
            self.ShengYuDianLiangBaiFe =  [info toInt16:10];
            self.KMH2 = [info toInt16:12];
        }
    }
    
    return self;
}

-(void)setSysStatus2:(int)sysStatus2{
    _sysStatus2 = sysStatus2;
    if (sysStatus2) { 
        self.xiansu = sysStatus2 & 0x0001 ;
        self.suoche = (sysStatus2 & 0x0002) >> 1 ;
        self.yK = (sysStatus2 & 0x0010) >> 4;
        self.zhanren = (sysStatus2 & 0x0400) >> 10;
        self.lingqi = (sysStatus2 & 0x4000) >> 14;
    }
}
@end
