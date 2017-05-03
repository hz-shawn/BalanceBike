//
//  BBSpeedSetting.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/15.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBSpeedSetting.h"
#import "MainApi.h"
#import "LimitSpeedModel.h"

#define BBSpeedSettingView @"BBSpeedSettingView"
@interface BBSpeedSetting ()

@end

@implementation BBSpeedSetting

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.scrollEnabled = false;
    //查询当前的限速值
    [MainApi getLimitSpeedInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSpeed:) name:LimitSpeedModelNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)changeValue:(id)sender {
    if (isMi) {
         self.limitSpeedLabel.text  = [NSString stringWithFormat:@"%dMi/h",(int)toMi(self.slider.value)];
    }else{
         self.limitSpeedLabel.text  = [NSString stringWithFormat:@"%dKm/h",(int)self.slider.value];
    }
   
    //设置Value
    [MainApi setLimitSpeedInfo:self.peripheral writeCharacteristic:self.writeCharacteristic speed:self.slider.value * 1000];
    
}

-(void)getSpeed:(NSNotification *)notification{
    LimitSpeedModel *model = (LimitSpeedModel *)notification.object;
    if (isMi) {
         self.limitSpeedLabel.text = [NSString stringWithFormat:@"%dMi/h",(int)toMi(model.XianSuSet/1000)];
    }else{
         self.limitSpeedLabel.text = [NSString stringWithFormat:@"%dKm/h",(int) model.XianSuSet/1000];
    }
   
    self.slider.value = model.XianSuSet/1000;
}


@end
