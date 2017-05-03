//
//  BBSpeedSetting.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/15.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface BBSpeedSetting : BBBasicTableViewController

@property (weak, nonatomic) IBOutlet UISlider *slider; //slider

@property (weak, nonatomic) IBOutlet UILabel *limitSpeedLabel; //限速的值


@end
