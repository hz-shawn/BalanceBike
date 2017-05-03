//
//  BBBasicViewController.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/16.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBBasicViewController : UIViewController
@property (strong,nonatomic) BabyBluetooth *baby;
@property (nonatomic,strong) CBPeripheral *peripheral;
@property (strong,nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong,nonatomic) CBCharacteristic *readCharacteristic;
@end
