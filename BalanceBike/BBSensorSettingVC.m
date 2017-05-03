//
//  BBSensorSettingVC.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/15.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBSensorSettingVC.h"

@interface BBSensorSettingVC () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *autoTurnAroundSensorSwitch; //转向灵敏度自动调节开关
@property (weak, nonatomic) IBOutlet UILabel *autoTurnAroundLabel;
@property (weak, nonatomic) IBOutlet UISlider *TurnAroundSensorSlider; //转向灵敏度slider
@property (weak, nonatomic) IBOutlet UITableViewCell *turnAroundCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *rideSensorCell;

@property (weak, nonatomic) IBOutlet UILabel *rideSensorAutoLabel;
@property (weak, nonatomic) IBOutlet UISwitch *rideSensorAutoSwitch; //骑行灵敏度自动调节开关
@property (weak, nonatomic) IBOutlet UISlider *rideSensorSlider; //骑行灵敏度slider
@property (weak, nonatomic) IBOutlet UILabel *assistLabel;
@property (weak, nonatomic) IBOutlet UISlider *assistSlider; //助理模式平衡点

@property (strong ,nonatomic) NSTimer *timer;
@property (strong,nonatomic) BBSensorModel *model;

@end

@implementation BBSensorSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //查询当前的限速值
    [MainApi getSensorInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSensor:) name:BBSensorModelNotification object:nil];
    
    
}


-(void)getSensor:(NSNotification *)notification{
    BBSensorModel *model = (BBSensorModel *)notification.object;
    self.model = model;
}

-(void)setModel:(BBSensorModel *)model{
    _model = model;
    if (model) {
        if (model.ShouBaLingMingDu == 101) {
            [self.autoTurnAroundSensorSwitch setOn:YES];
        }else{
            [self.autoTurnAroundSensorSwitch setOn:NO];
            self.TurnAroundSensorSlider.value = model.ShouBaLingMingDu;
            self.autoTurnAroundLabel.text = [NSString stringWithFormat:@"%d",model.ShouBaLingMingDu];
        }
        
        if(model.QiXingLingMinDu == 101){
            [self.rideSensorAutoSwitch setOn:YES];
        }else{
            [self.rideSensorAutoSwitch setOn:NO];
            self.rideSensorSlider.value = model.QiXingLingMinDu;
            self.rideSensorAutoLabel.text = [NSString stringWithFormat:@"%d",model.QiXingLingMinDu];
        }
        float pinghengdian = model.ZhuLiPhengDian * 0.1 > 20 ? (model.ZhuLiPhengDian - 65535) * 0.1 : model.ZhuLiPhengDian * 0.1;
        self.assistLabel.text = [NSString stringWithFormat:@"%.1f",pinghengdian];
        self.assistSlider.value = pinghengdian;
        
        [self.tableView reloadData];
    }
}
- (IBAction)turnAroundChange:(id)sender {
    self.autoTurnAroundLabel.text = [NSString stringWithFormat:@"%d",(int)self.TurnAroundSensorSlider.value];
    //设置值
    [MainApi setShouBaLingMingDuInfo:self.peripheral writeCharacteristic:self.writeCharacteristic ShouBaLingMingDu:self.TurnAroundSensorSlider.value];
}

- (IBAction)rideSensorChange:(id)sender {
    self.rideSensorAutoLabel.text =[NSString stringWithFormat:@"%d",(int)self.rideSensorSlider.value];
    //设置值
    [MainApi setQiXingLinMingDuInfo:self.peripheral writeCharacteristic:self.writeCharacteristic QiXingLinMingDu:self.rideSensorSlider.value];
}
- (IBAction)assistChange:(id)sender {
    self.assistLabel.text = [NSString stringWithFormat:@"%.1f",self.assistSlider.value];
    //设置值
    [MainApi setZhuLiPingHengInfo:self.peripheral writeCharacteristic:self.writeCharacteristic ZhuLiPingHeng:self.assistSlider.value *10];
}
//转向灵敏度调节
- (IBAction)aroundSwitchChange:(id)sender {
    if(self.autoTurnAroundSensorSwitch.isOn){
        [MainApi setShouBaLingMingDuInfo:self.peripheral writeCharacteristic:self.writeCharacteristic ShouBaLingMingDu:101];
    }else{
        [MainApi setShouBaLingMingDuInfo:self.peripheral writeCharacteristic:self.writeCharacteristic ShouBaLingMingDu:self.TurnAroundSensorSlider.value];
    }
    [MainApi getSensorInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];
    
}
//骑行灵敏度开关调节
- (IBAction)rideSwitchChange:(id)sender {
    
    if (self.rideSensorAutoSwitch.isOn) {
        [MainApi setQiXingLinMingDuInfo:self.peripheral writeCharacteristic:self.writeCharacteristic QiXingLinMingDu:101];
    }else{
        [MainApi setQiXingLinMingDuInfo:self.peripheral writeCharacteristic:self.writeCharacteristic QiXingLinMingDu:self.rideSensorSlider.value];
    }
    [MainApi getSensorInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 2) {
        return self.model.ShouBaLingMingDu == 101 ? 0 : 90 ;
    }
    if (indexPath.row == 4) {
        return self.model.QiXingLingMinDu == 101 ? 0 : 90 ;
    }
    if (indexPath.row == 5) {
        return 90;
    }
    
    return 60;
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        //姿态传感器校准
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"标定传感器需要锁车，是否继续？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 100;
        [alertView show];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        //锁车
        if (buttonIndex == 1) {
            [MainApi suoche:self.peripheral writeCharacteristic:self.writeCharacteristic];
            
            UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"提示" message:@"在姿态传感器校准过程中请保持车辆处于绝对静止状态，标定过程持续大约3秒,是否继续?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 101;
            [alert show];
        }
    }
    
    if (alertView.tag == 101) {
        //校准
        if (buttonIndex == 1) {
            
            [MainApi jiaozhun:self.peripheral writeCharacteristic:self.writeCharacteristic];
            
            //3秒后解锁
            [self performSelector:@selector(action) withObject:self afterDelay:3.0];
            
        }
    }
}

-(void)action{
    [MainApi jiesuo:self.peripheral writeCharacteristic:self.writeCharacteristic];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.timer invalidate];
    self.timer = nil;
}
@end
