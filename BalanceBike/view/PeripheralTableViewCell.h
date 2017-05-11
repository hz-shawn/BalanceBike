//
//  PeripheralTableViewCell.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/1.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"

@interface PeripheralTableViewCell : UITableViewCell

@property (nonatomic,strong) CBPeripheral *peripheral;
 
@end
