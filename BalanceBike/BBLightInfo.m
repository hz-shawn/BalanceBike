//
//  BBLightInfo.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/25.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBLightInfo.h"

@implementation BBLightInfo
-(instancetype)initWith:(NSArray *)info{
    if (info) {
        if (info) {
            self.moshi = [info toInt16:6];
            self.light1 = [info toInt16:11];
            self.light2 = [info toInt16:15];
            self.light3 = [info toInt16:19];
            self.light4 = [info toInt16:23];
            
            self.lights = @[@(self.light1),@(self.light2),@(self.light3),@(self.light4)];
        }
    }
    
    return self;
}


@end
