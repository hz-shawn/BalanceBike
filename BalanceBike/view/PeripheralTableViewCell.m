//
//  PeripheralTableViewCell.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/1.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "PeripheralTableViewCell.h"

@interface PeripheralTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *machineNameLabel;

@end

@implementation PeripheralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setPeripheral:(CBPeripheral *)peripheral{
    _peripheral = peripheral;
    
    if (_peripheral) {
        NSString *name = peripheral.name;
        if(self.oldmachineName && self.machineName && [name isEqualToString:self.oldmachineName]){
            name = self.machineName;
        }  
        self.machineNameLabel.text = peripheral.name.length > 0 ?  [name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]: @"UNKnow Name";
    }
    
}
@end
