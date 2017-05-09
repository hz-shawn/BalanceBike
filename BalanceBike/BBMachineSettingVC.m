//
//  BBMachineSettingVC.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/15.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBMachineSettingVC.h"

@interface BBMachineSettingVC ()
@property (weak, nonatomic) IBOutlet UILabel *currentSpeed;
@property (weak, nonatomic) IBOutlet UILabel *avgSpeed;
@property (weak, nonatomic) IBOutlet UILabel *totalKM;
@property (weak, nonatomic) IBOutlet UILabel *thisKM;
@property (weak, nonatomic) IBOutlet UILabel *thisTime;
@property (weak, nonatomic) IBOutlet UILabel *tempreture;
@property (weak, nonatomic) IBOutlet UILabel *highSpeed;
@property (strong,nonatomic) NSTimer *mainViewModelTimer;
@end

@implementation BBMachineSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMainInfo:) name:MainViewModelNotification object:nil];
    [self.mainViewModelTimer fire];
}


-(void)getMainInfo:(NSNotification *)notification{
    MainViewModel *model = (MainViewModel *)notification.object;
    if(isMi){
        self.currentSpeed.text = [NSString stringWithFormat:@"%.1fmph", toMi(model.KMH2 * 0.001) ];
        self.avgSpeed.text = [NSString stringWithFormat:@"%.1fmph",toMi(model.PJSpeed1 * 0.001)];
        self.totalKM.text =  [NSString stringWithFormat:@"%.1fmI",toMi(model.KMTotal2 * 0.001)];
        self.thisKM.text =  [NSString stringWithFormat:@"%.1fmI",toMi(model.KMS * 0.01)];
        self.thisTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d",model.SigRunTime2/3600,(model.SigRunTime2%3600)/60,model.SigRunTime2%60];
        self.tempreture.text = [NSString stringWithFormat:@"%.1f℉",model.Temperature2 * 0.1*1.8 + 32];
        self.highSpeed.text = [NSString stringWithFormat:@"%.1fmph",toMi(model.MaxAbsKMH * 0.001)];
    }else{
        self.currentSpeed.text = [NSString stringWithFormat:@"%.1fKm/h",model.KMH2 * 0.001];
        self.avgSpeed.text = [NSString stringWithFormat:@"%.1fKm/h",model.PJSpeed1 * 0.001];
        self.totalKM.text =  [NSString stringWithFormat:@"%.1fKm",model.KMTotal2 * 0.001];
        self.thisKM.text =  [NSString stringWithFormat:@"%.1fKm",model.KMS * 0.01];
        self.thisTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d",model.SigRunTime2/3600,(model.SigRunTime2%3600)/60,model.SigRunTime2%60];
        self.tempreture.text = [NSString stringWithFormat:@"%.1f℃",model.Temperature2 * 0.1];
        self.highSpeed.text = [NSString stringWithFormat:@"%.1fKm/h",model.MaxAbsKMH * 0.001];
    }

   
}
-(void)viewWillDisappear:(BOOL)animated {
    [_mainViewModelTimer invalidate];
    _mainViewModelTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSTimer *)mainViewModelTimer{
    if (!_mainViewModelTimer) {
        _mainViewModelTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(mainTimerLoop) userInfo:nil repeats:YES];
    }
    return _mainViewModelTimer;
}



-(void)mainTimerLoop{
    //如果断开连接了 这里就什么都不做
    if(self.peripheral){
        
        [MainApi getMainInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];
    }else{
        [_mainViewModelTimer invalidate];
        _mainViewModelTimer = nil;
    }
}


@end
