//
//  BBBatteryInfo.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/16.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBBatteryInfo : NSObject
@property (nonatomic,assign) int ShengYuDianLiang; //剩余电量
@property (nonatomic,assign) int BaiFenBi; //剩余百分比
@property (nonatomic,assign) int DianLiu; //电流
@property (nonatomic,assign) int DianYa; //电压
@property (nonatomic,assign) int Temprer1; //温度
@property (nonatomic,assign) int Temprer2; //温度

-(instancetype)initWith:(NSArray *)info;
@end
