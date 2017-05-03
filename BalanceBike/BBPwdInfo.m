//
//  BBPwdInfo.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/18.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBPwdInfo.h"

@implementation BBPwdInfo
-(instancetype)initWith:(NSArray *)info{
    if (info) {
        NSMutableString *pwd = [NSMutableString string];
        for(int i = 0;i < 6;i++){
      
            [pwd appendString:[NSString stringWithFormat:@"%c",[info[6 + i] intValue]]];
        }
        
        self.pwd = pwd;
    }
    
    return self;
}
@end
