//
//  MainApi.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/15.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyBluetooth.h"
@interface MainApi : NSObject
+(void)getSystemInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic; //查询系统信息
+(void)getMainInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic; //查询主界面信息
+(void)getLimitSpeedInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic; //查询限速信息
+(void)setLimitSpeedInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic speed:(int)speed; //设置速度
+(void)getSensorInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;//查询灵敏度
+(void)setShouBaLingMingDuInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic ShouBaLingMingDu:(int)lmd; //设置转向灵敏度
+(void)setQiXingLinMingDuInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic QiXingLinMingDu:(int)lmd;//设置骑行灵敏度
+(void)setZhuLiPingHengInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic ZhuLiPingHeng:(int)lmd;//设置助理平衡点
+(void)jiaozhun:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;//校准
+(void)getBatteryInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;//查询电量

+(void)getAlertModelInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;//查询AlertModel

+(void)setAlertModelInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic DengGuanBao:(int)value;//查询AlertModel


+(void)setMachineNameInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic name:(NSData *)nameData;//设置蓝牙名称

+(void)getPWDInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;//查询密码
+(void)setpwdInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic pwd:(NSString *)pwd;//设置蓝牙名称
+(void)xiansu:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;//限速
+(void)jieChuxiansu:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;//解除限速
+(void)getHeiXiaZiInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic index:(int)index;//查询黑匣子信息
+(void)getLightInfo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;//查询灯光信息
+(void)suoche:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;//锁车
+(void)jiesuo:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;//解锁车
+(void)suocheWithoutAlert:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;//锁车后不告警
+(void)setColor:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic lightId:(int)lightId color:(int) color;//设置颜色

+(void)setmoshi:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic  moshi:(int) moshi;//设置灯模式

+(void)setYKSpeed:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic  speed: (float) speed;//设置遥控限速值
+(void)getYKXianSu:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;//查询遥控限速值
+(void)setYkModel:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic; //进入遥控模式
+(void)quiteYkModel:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic; //退出遥控模式
+(void)setYkSpeed:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic x:(int)x y:(int)y;//设置速度
+(void)getYkStatus:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;   //查询遥控的状态
+(void)shutDown:(CBPeripheral *)peripheral  writeCharacteristic:(CBCharacteristic *)writeCharacteristic;   //关机

@end
