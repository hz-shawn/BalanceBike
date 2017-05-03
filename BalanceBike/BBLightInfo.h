//
//  BBLightInfo.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/25.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBLightInfo : NSObject
@property (nonatomic,assign) int moshi; //尾灯模式
@property (nonatomic,assign) int light1; //灯光1
@property (nonatomic,assign) int light2; //灯光2
@property (nonatomic,assign) int light3; //灯光3
@property (nonatomic,assign) int light4; //灯光4

@property (nonatomic,strong) NSArray *lights;
-(instancetype)initWith:(NSArray *)info;
@end
