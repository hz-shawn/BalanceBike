//
//  AppDelegate.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/2/28.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) BabyBluetooth *baby;
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (strong,nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong,nonatomic) CBCharacteristic *readCharacteristic;

@end

