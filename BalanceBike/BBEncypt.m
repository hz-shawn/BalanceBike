//
//  BBEncypt.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/9.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBEncypt.h"

@implementation BBEncypt

+(Byte *)unEncypt:(Byte *)bytes count:(NSUInteger)count{
    for (int i = 0 ; i < count ;  i++) {
        bytes[i] = unencrypt_table[bytes[i]];
    }
    return bytes;
}

@end
