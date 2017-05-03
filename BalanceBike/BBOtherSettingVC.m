//
//  BBOtherSettingVC.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/15.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBOtherSettingVC.h"

@interface BBOtherSettingVC () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *lockShutDownSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lockWarningSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *openFrontLightSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *openShutDownSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *backFastWarningSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *danweiSwitch;
@property (strong,nonatomic) MainViewModel *viewModel;
@end

@implementation BBOtherSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [MainApi getAlertModelInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];
    
//    self.danweiSwitch.isOn = isMi;
    self.danweiSwitch.on = isMi;
}

-(void)viewWillAppear:(BOOL)animated{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInfo:) name:BBAlertInfoNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSpeedInfo:) name:MainViewModelNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getInfo:(NSNotification *)notification{
    BBAlertModel *model = (BBAlertModel *)notification.object;
    self.lockShutDownSwitch.on = model.lockAllowShutDown;
    self.lockWarningSwitch.on = model.lockAllowWarning;
    self.openFrontLightSwitch.on = model.openFrontLight;
    self.openShutDownSwitch.on = model.openStopLight;
    self.backFastWarningSwitch.on = model.backFastWarning;
}
-(void)getSpeedInfo:(NSNotification *)notification{
    MainViewModel *model = (MainViewModel *)notification.object;
    self.viewModel = model;
}


- (IBAction)switchChange:(id)sender {
    NSInteger value = (self.lockShutDownSwitch.isOn)*self.lockShutDownSwitch.tag +
                      (self.lockWarningSwitch.isOn)*self.lockWarningSwitch.tag +
                      (self.openFrontLightSwitch.isOn)*self.openFrontLightSwitch.tag +
                      (self.openShutDownSwitch.isOn)*self.openShutDownSwitch.tag +
                      (self.backFastWarningSwitch.isOn)*self.backFastWarningSwitch.tag;
    
    [MainApi setAlertModelInfo:self.peripheral writeCharacteristic:self.writeCharacteristic DengGuanBao:(int)value];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        //关机 要求非骑行模式
        if(self.viewModel.workmode2 == 2){
            [SVProgressHUD showInfoWithStatus:@"骑行模式下不能关机"];
            return;
        }
            
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"要关闭车辆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [MainApi shutDown:self.peripheral writeCharacteristic:self.writeCharacteristic];
    }
}

- (IBAction)danweiChange:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:self.danweiSwitch.on forKey:@"Mi"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}


@end
