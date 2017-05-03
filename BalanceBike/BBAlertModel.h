//
//  BBAlertModel.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/18.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBAlertModel : NSObject
@property (nonatomic,assign) int DengGuanBao;

@property (nonatomic,assign) BOOL openFrontLight;//开关前灯
@property (nonatomic,assign) BOOL openStopLight; //开关刹车灯
@property (nonatomic,assign) BOOL lockAllowShutDown;  //锁车后允许关机
@property (nonatomic,assign) BOOL lockAllowWarning;   //锁车后不警告
@property (nonatomic,assign) BOOL backFastWarning; //后退过快报警



-(instancetype)initWith:(NSArray *)info;
@end
