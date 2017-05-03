//
//  BBYKSpeed.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/31.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBYKSpeed.h"

@implementation BBYKSpeed
-(instancetype)initWith:(NSArray *)info{
    if (info) {
        if (info) {
            self.speed = [info toInt16:6] / 1000.0;
        }
    }
    
    return self;
}
@end
