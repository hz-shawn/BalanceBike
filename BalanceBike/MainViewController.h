//
//  MainViewController.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/5.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"

@interface MainViewController : UIViewController <UIAlertViewDelegate>
@property (strong,nonatomic) BabyBluetooth *baby;
@property (nonatomic,strong) CBPeripheral *peripheral;

@end
