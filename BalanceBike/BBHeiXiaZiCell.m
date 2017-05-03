//
//  BBHeiXiaZiCell.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/20.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBHeiXiaZiCell.h"
@interface BBHeiXiaZiCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *HXZCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorCodeLabel;

@end
@implementation BBHeiXiaZiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(BBHeiXiaZiInfo *)model{
    _model = model;
    if (model) {
        self.timeLabel.text = [NSString stringWithFormat:@"%dh %dm %ds",model.time/3600,(model.time % 3600)/60,model.time%60];
        self.HXZCodeLabel.text = [NSString stringWithFormat:@"%d",model.code];
        self.errorCodeLabel.text = [NSString stringWithFormat:@"%d",model.errorCode];
    }
}

@end
