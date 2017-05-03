//
//  LimitSpeedModel.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/15.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+BB.h"

@interface LimitSpeedModel : NSObject

@property (nonatomic,assign) int XianSuSet;//限速值
 
-(instancetype)initWith:(NSArray *)info;

@end
