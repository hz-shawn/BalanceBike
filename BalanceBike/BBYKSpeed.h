//
//  BBYKSpeed.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/31.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBYKSpeed : NSObject
@property (nonatomic,assign) CGFloat speed; //速度

-(instancetype)initWith:(NSArray *)info;
@end
