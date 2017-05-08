//
//  BBBatterySettingVC.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/15.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBBatterySettingVC.h"

@interface BBBatterySettingVC ()
@property (weak, nonatomic) IBOutlet UILabel *ShengYuDianLiang;
@property (weak, nonatomic) IBOutlet UILabel *BaiFenBi;
@property (weak, nonatomic) IBOutlet UILabel *DianLiu;
@property (weak, nonatomic) IBOutlet UILabel *DianYa;
@property (weak, nonatomic) IBOutlet UILabel *Temprer;
@property (strong,nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *gonglvLabel;

@end

@implementation BBBatterySettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.timer fire];
}

-(void)viewWillAppear:(BOOL)animated{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBatteryInfo:) name:BBBatteryInfoNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getBatteryInfo:(NSNotification *)notification{
    BBBatteryInfo *model = (BBBatteryInfo *)notification.object;
    //设置信息
    self.ShengYuDianLiang.text = [NSString stringWithFormat:@"%dmAh",model.ShengYuDianLiang];
    self.BaiFenBi.text = [NSString stringWithFormat:@"%d%%",model.BaiFenBi];
    self.DianLiu.text = [NSString stringWithFormat:@"%.2fA",model.DianLiu * 0.001 > 40 ? (0xffff - model.DianLiu) * 0.001 : model.DianLiu * 0.001  ];
    self.DianYa.text  = [NSString stringWithFormat:@"%.1fV",model.DianYa * 0.01];
    self.Temprer.text = [NSString stringWithFormat:@"%d℃",(int)((model.Temprer1 + model.Temprer2) * 0.5 - 20)];
    self.gonglvLabel.text = [NSString stringWithFormat:@"%.1fW",model.DianYa * 0.01 * (model.DianLiu * 0.001 > 40 ? (0xffff - model.DianLiu) * 0.001 : model.DianLiu * 0.001)];
}



-(NSTimer *)timer{
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerLoop) userInfo:nil repeats:YES];

        }
        return _timer;
}

-(void)timerLoop{
    [MainApi getBatteryInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];
}
@end
