//
//  BBHeiXiaZiInfo.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/20.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBHeiXiaZiInfo.h"

@implementation BBHeiXiaZiInfo
-(instancetype)initWith:(NSArray *)info{
    if (info) {
        self.time = [info toInt32:7];
        self.code = [info toInt16:11];
        self.errorCode = [info toInt16:13];
    }
    return self;
}
@end
