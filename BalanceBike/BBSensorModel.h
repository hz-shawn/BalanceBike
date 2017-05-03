//
//  BBSensorModel.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/16.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSensorModel : NSObject

@property (nonatomic,assign) int ShouBaLingMingDu; //转弯手把灵敏度
@property (nonatomic,assign) int QiXingLingMinDu; //骑行灵敏度
@property (nonatomic,assign) int ZhuLiPhengDian; //助力模式下的平衡点


-(instancetype)initWith:(NSArray *)info;
@end
