//
//  BBSystemInfo.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/10.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+BB.h"

@interface BBSystemInfo : NSObject

@property (nonatomic,copy) NSString *cardId;                //卡号 （ASC码）
@property (nonatomic,copy) NSString *defaultBlePsw1;        //蓝牙密码 （ASC码）
@property (nonatomic,copy) NSString *version;               //主板版本号
@property (nonatomic,assign) int errCode1;//错误代码
@property (nonatomic,assign) int warning1; //警告
@property (nonatomic,assign) int sysStatus; 

-(instancetype)initWith:(NSArray *)info;

@end
