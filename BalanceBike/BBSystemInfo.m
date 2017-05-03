//
//  BBSystemInfo.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/10.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBSystemInfo.h"

@implementation BBSystemInfo

-(instancetype)initWith:(NSArray *)info{
    if (info) {
        NSString *cardId = [info toString:6 len:14];
        if ([cardId hasPrefix:@"11960/"] || [cardId hasPrefix:@"201702"]) {
            self.cardId = cardId;
        } 
        self.defaultBlePsw1 = [info toString:20 len:6];
        self.version = [NSString stringWithFormat:@"%x.%x",[info[27] intValue],[info[26] intValue]];
        self.errCode1 = [info toInt16:28];
        self.warning1 = [info toInt16:30];
        self.sysStatus = [info toInt16:32];
    }
    
    return self;
}


@end
