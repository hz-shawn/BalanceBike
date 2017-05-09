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
@end

@implementation BBMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMainInfo:) name:MainViewModelNotification object:nil];
}


-(void)getMainInfo:(NSNotification *)notification{
    MainViewModel *model = (MainViewModel *)notification.object;
    self.viewModel = model;
 
}
-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        //判断当前的模式 如果不是助理模式 或者待机模式 提示不能读取黑匣子
        if (self.viewModel.workmode2 != 1) {
            [SVProgressHUD showInfoWithStatus:@"非助力模式不能读取黑匣子信息"];
        }else{
                [self performSegueWithIdentifier:@"hxz" sender:nil];
        }
        
    }
}
 

@end
