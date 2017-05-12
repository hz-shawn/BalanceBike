//
//  BBMoreViewController.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/24.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBMoreViewController.h"

@interface BBMoreViewController ()
@property (strong,nonatomic) MainViewModel *viewModel;
@property (strong,nonatomic) NSTimer *timer;
@end

@implementation BBMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.timer fire];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMainInfo:) name:MainViewModelNotification object:nil];
}


-(void)getMainInfo:(NSNotification *)notification{
    MainViewModel *model = (MainViewModel *)notification.object;
    self.viewModel = model;
 
}
-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.timer invalidate];
    self.timer = nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        //判断当前的模式 如果不是助理模式 或者待机模式 提示不能读取黑匣子
        if (self.viewModel.workmode2 != 1) {
            [SVProgressHUD showInfoWithStatus:@"请先进入非骑行模式"];
        }else{
                [self performSegueWithIdentifier:@"hxz" sender:nil];
        }
        
    }
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerLoop) userInfo:nil repeats:YES];
        
    }
    return _timer;
}

-(void)timerLoop{
    [MainApi getMainInfo:self.peripheral writeCharacteristic:self.writeCharacteristic ];
}

@end
