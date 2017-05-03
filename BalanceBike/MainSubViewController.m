//
//  MainSubViewController.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/5.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "MainSubViewController.h"
#define KTransformTime 1
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KsubTableViewHeight KScreenHeight

@interface MainSubViewController () <UIGestureRecognizerDelegate,UIAlertViewDelegate>

 

@end

@implementation MainSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIFont *font = [UIFont fontWithName:@"Block Condensed" size:80];
    self.currentSpeedLabel.font = font;
    self.currentSpeedLabel.alpha = 0;
    self.danweiLabel.alpha = 0;
    self.view.backgroundColor = [UIColor clearColor];
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor, (__bridge id)[UIColor colorWithHex:0x4c4a48].CGColor, (__bridge id)[UIColor blackColor].CGColor];
//    gradientLayer.locations = @[@0, @0.3, @0.7];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake( 0, 1);
//    gradientLayer.frame = self.view.frame;
//    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
//    UISwipeGestureRecognizer *recognizer =    [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [recognizer setDirection:UISwipeGestureRecognizerDirectionDown];
//    recognizer.delegate = self;
//    [self.tableView addGestureRecognizer:recognizer];
    
    self.researchBtn.layer.cornerRadius = 22;
    self.researchBtn.layer.masksToBounds = YES;
    self.researchBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.researchBtn.layer.borderWidth = 1.0f;
}


-(void)setViewModel:(MainViewModel *)viewModel{
    _viewModel = viewModel;
    if (_viewModel) {
        //设置UI部分
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            if (isMi) {
                self.thisKMLabel.text =  [NSString stringWithFormat:@"%.1fMi",toMi(ceil(viewModel.KMS * 0.1) *0.1) ];
                self.leftKMLabel.text = [NSString stringWithFormat:@"%dMi",(int)toMi(viewModel.ShengYuDianLiangBaiFenBi2 * 0.2)];
                self.avgSpeedLabel.text = [NSString stringWithFormat:@"%.1fMi/h",toMi(viewModel.PJSpeed1 * 0.001)];
                self.currentSpeedLabel.text =[NSString stringWithFormat:@"%.1f ",toMi(viewModel.KMH2 * 0.001)];
                self.danweiLabel.text = @"Mi/h";
            }else{
                self.thisKMLabel.text =  [NSString stringWithFormat:@"%.1fKm",ceil(viewModel.KMS * 0.1) *0.1];
                self.leftKMLabel.text = [NSString stringWithFormat:@"%dKm",(int)(viewModel.ShengYuDianLiangBaiFenBi2 * 0.2)];
                self.avgSpeedLabel.text = [NSString stringWithFormat:@"%.1fKm/h",viewModel.PJSpeed1 * 0.001];
                self.currentSpeedLabel.text =[NSString stringWithFormat:@"%.1f ",viewModel.KMH2 * 0.001];
                  self.danweiLabel.text = @"Km/h";
            }
          
        });
    }
}

//-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
//    
//    
//    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
//        
//        [UIView animateWithDuration:KTransformTime animations:^{
//            //container 透明度 
//            self.containerView.alpha = 1;
//            self.view.frame = CGRectMake(0, KScreenHeight * 0.5, KScreenWidth,  KsubTableViewHeight);
//            self.view.alpha = 0;
//            
//        } completion:^(BOOL finished) {
//            //隐藏subTableview
//        }];
//        
//    }
//}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}

- (IBAction)researchBtn:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"需要进入重新搜索吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    
   
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)xiansuClick:(id)sender {
    
}

- (IBAction)suoClick:(id)sender {
    
}
- (IBAction)yaokongClick:(id)sender {
    
}


@end
