//
//  NSArray+BB.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/10.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "NSArray+BB.h"

@implementation NSArray (BB)

-(NSString *)toString:(int) index len:(int) len{
  
        NSArray *subArray = [self subarrayWithRange:NSMakeRange(index, len)];
        NSMutableString *cards = [NSMutableString string];
        for (int i = 0; i < [subArray count]; i++) {
            [cards appendString:[NSString stringWithFormat:@"%c",[subArray[i] intValue] ]];
        }
    
    return cards;
}
-(int)toInt16:(int) index{
    NSArray *subArray = [self subarrayWithRange:NSMakeRange(index, 2)];
    
    int end = [subArray[1] intValue];
    int begin = [subArray[0] intValue];
    int result = (end << 8) + begin;
    return result;
}

-(int)toInt32:(int) index{
    NSArray *subArray = [self subarrayWithRange:NSMakeRange(index, 4)];
    int forth = [subArray[3] intValue];
    int third = [subArray[2] intValue];
    int second = [subArray[1] intValue];
    int first = [subArray[0] intValue];
    int result = (second << 8) + first + (third << 16) + (forth << 24);
    return result;
}

@end
