//
//  BBAlertModel.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/18.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBAlertModel.h"

@implementation BBAlertModel
-(instancetype)initWith:(NSArray *)info{
    if (info) {
        self.DengGuanBao = [info toInt16:6];
    }
    
    return self;
}

-(void)setDengGuanBao:(int)DengGuanBao{
    _DengGuanBao = DengGuanBao;
    self.openFrontLight  = DengGuanBao & 0x0001 ;
    self.openStopLight = (DengGuanBao & 0x0002) >> 1; //开关刹车灯
    self.lockAllowShutDown =(DengGuanBao & 0x0004) >> 2;  //锁车后允许关机
    self.lockAllowWarning = (DengGuanBao & 0x0008) >> 3;   //锁车后警告
    self.backFastWarning = (DengGuanBao & 0x0010) >> 4;
}
@end
