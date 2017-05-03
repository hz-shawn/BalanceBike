//
//  BBHeiXiaZiInfo.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/20.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBHeiXiaZiInfo : NSObject
@property (nonatomic,assign) int time;
@property (nonatomic,assign) int code;
@property (nonatomic,assign) int errorCode;

-(instancetype)initWith:(NSArray *)info;

@end
