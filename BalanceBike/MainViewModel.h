//
//  MainViewModel.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/10.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainViewModel : NSObject

@property (nonatomic,assign) int errCode2;//错误代码
@property (nonatomic,assign) int wangning2; //警告代码
@property (nonatomic,assign) int sysStatus2;//系统状态
@property (nonatomic,assign) int workmode2;//工作模式  0待机 1.助力 2.骑行 3.锁车 4遥控
@property (nonatomic,assign) int ShengYuDianLiangBaiFenBi2; //剩余电量百分比
@property (nonatomic,assign) int KMH2; //速度
@property (nonatomic,assign) int PJSpeed1; //平均速度
@property (nonatomic,assign) int KMTotal2; //总里程
@property (nonatomic,assign) int KMS; //本次里程
@property (nonatomic,assign) int SigRunTime2; //本次运行时间
@property (nonatomic,assign) int Temperature2; //温度
@property (nonatomic,assign) int SpeedLimitNow; //当前模式的限速值
@property (nonatomic,assign) int DianLiu2; //电流
@property (nonatomic,assign) int MaxAbsKMH; //最高速度


@property (nonatomic,assign) int xiansu; //限速
@property (nonatomic,assign) int suoche; //锁车
@property (nonatomic,assign) int yaokong; //遥控
@property (nonatomic,assign) int zhanren; //战人模式
@property (nonatomic,assign) int lingqi; //拎起模式






-(instancetype)initWith:(NSArray *)info;
@end
