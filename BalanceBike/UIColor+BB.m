//
//  UIColor+BB.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/24.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "UIColor+BB.h"

@implementation UIColor (BB)
+ (UIColor*) colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}
@end
