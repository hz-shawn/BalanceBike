//
//  BBPwdInfo.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/18.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBPwdInfo : NSObject

@property (nonatomic,copy) NSString *pwd;
 
-(instancetype)initWith:(NSArray *)info;
@end
