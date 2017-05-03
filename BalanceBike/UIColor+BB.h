//
//  UIColor+BB.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/24.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BB)
+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
@end
