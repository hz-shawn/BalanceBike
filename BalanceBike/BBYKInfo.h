//
//  BBYKInfo.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/31.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBYKInfo : NSObject
@property (nonatomic,assign) int sysStatus2; //系统工作状态
@property (nonatomic,assign) int workmode2; //系统工作状态
@property (nonatomic,assign) int ShengYuDianLiangBaiFe; //系统工作状态
@property (nonatomic,assign) int KMH2; //系统工作状态

@property (nonatomic,assign) BOOL xiansu; //限速模式
@property (nonatomic,assign) BOOL suoche; //锁车模式
@property (nonatomic,assign) BOOL yK; //遥控模式
@property (nonatomic,assign) BOOL zhanren; //战人模式
@property (nonatomic,assign) BOOL lingqi; //拎起模式


-(instancetype)initWith:(NSArray *)info;
@end
