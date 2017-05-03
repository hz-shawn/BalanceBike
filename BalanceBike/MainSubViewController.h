//
//  MainSubViewController.h
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/5.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewModel.h"

@interface MainSubViewController : UITableViewController

 
@property (weak, nonatomic) IBOutlet UILabel *thisKMLabel;     //本次里程
 
@property (weak, nonatomic) IBOutlet UILabel *avgSpeedLabel;   //平均速度
@property (weak, nonatomic) IBOutlet UILabel *leftKMLabel; //剩余行驶里程

@property (strong,nonatomic) MainViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *currentSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *danweiLabel;

@property (weak,nonatomic) UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *researchBtn;

@property (weak, nonatomic) IBOutlet UIButton *xuansuBtn;
@property (weak, nonatomic) IBOutlet UIButton *suoBtn;
@property (weak, nonatomic) IBOutlet UIButton *yaokongBtn;

@end
