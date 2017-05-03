//
//  BBLightSettingVC.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/15.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBLightSettingVC.h"
#import "IndicatorView.h"
#import "BBLightFenWeiSettingVC.h"

@interface BBLightSettingVC ()

@property (nonatomic,weak)   IndicatorView *indicatorView ;
@property (weak, nonatomic) IBOutlet UIImageView *sehuanView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *lightBtns;
@property (weak,nonatomic) UIButton *selectedBtn;
@property (strong,nonatomic) BBLightInfo *lightInfo;
@property (strong,nonatomic) BBAlertModel *alertModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceCons;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *updownBtn;
@property (weak, nonatomic) IBOutlet UISwitch *frontSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *stopSwitch;

@end

@implementation BBLightSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = 291 *0.5;
    CGFloat height = 20;
   
    IndicatorView *view = [[IndicatorView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    view.layer.anchorPoint = CGPointMake(0, 0.5);
    view.center = CGPointMake(width   , width);
    
    [self.sehuanView addSubview:view];
    self.indicatorView = view;
    [self.view bringSubviewToFront:view];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    
    [self.view addGestureRecognizer:recognizer];
    
    
    for (UIButton *btn in self.lightBtns) {
        btn.layer.cornerRadius = 35;
        btn.layer.masksToBounds = YES;
    }
    self.selectedBtn = self.lightBtns.firstObject;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MainApi getLightInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];
    [MainApi getAlertModelInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];//灯查询
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInfo:) name:BBLightInfoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInfoSetting:) name:BBAlertInfoNotification object:nil];
    
}

-(void)getInfo:(NSNotification *)notification{
    BBLightInfo *model = (BBLightInfo *)notification.object;
    self.lightInfo = model;
}
-(void)getInfoSetting:(NSNotification *)notification{
    BBAlertModel *model = (BBAlertModel *)notification.object;
    self.alertModel = model;
}


-(void)swipe:(UIPanGestureRecognizer *)recognizer{
    CGPoint point = [recognizer locationInView:self.view];
    CGFloat roation = [self angleForStartPoint:self.sehuanView.center EndPoint:point];
    UIColor *color = [UIColor colorWithHue:roation  / (M_PI *2) saturation:1.0 brightness:1.0 alpha:1.0];
    self.indicatorView.color = color;
    self.indicatorView.transform = CGAffineTransformMakeRotation(roation);
    
    //当滑动结束的时候 获得颜色
//    if(recognizer.state == UIGestureRecognizerStateEnded){
        self.selectedBtn.backgroundColor = color;
        [MainApi setColor:self.peripheral writeCharacteristic:self.writeCharacteristic lightId:(int)self.selectedBtn.tag color:240 * (roation/ (M_PI * 2))];
//    }
    
}

-(CGFloat)angleForStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint{
    
    CGPoint Xpoint = CGPointMake(startPoint.x + 100, startPoint.y);
    
    CGFloat a = endPoint.x - startPoint.x;
    CGFloat b = endPoint.y - startPoint.y;
    CGFloat c = Xpoint.x - startPoint.x;
    CGFloat d = Xpoint.y - startPoint.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
    if (startPoint.y>endPoint.y) {
        rads =  -rads ;
    }
    rads =  rads < 0 ? rads + 2* M_PI :rads;
    return rads;
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)click:(id)sender {
    self.selectedBtn = sender;
}

-(void)setSelectedBtn:(UIButton *)selectedBtn{
    if (selectedBtn != _selectedBtn) {
        _selectedBtn.selected = NO;
        selectedBtn.selected = YES;
        _selectedBtn = selectedBtn;
        //设置色环的颜色
        if (self.lightInfo.lights.count != 4) {
            return;
        }
        self.indicatorView.color = selectedBtn.backgroundColor;
        int hue = 0;
        switch (selectedBtn.tag) {
            case 200:{
                hue  = self.lightInfo.light1;
                 break;
            }
            case 202:{
                  hue  =self.lightInfo.light2;
                 break;
            }
            case 204:{
                  hue  = self.lightInfo.light3;
                  break;
            }
            case 206:{
                  hue  =self.lightInfo.light4;
                  break;
            }
            default:{
                hue  = self.lightInfo.light1;
                break;
            }
        }
        CGFloat roation = 2 *(M_PI) *(hue/240.0);
        self.indicatorView.transform = CGAffineTransformMakeRotation(roation);
        
    }
}

-(void)setLightInfo:(BBLightInfo *)lightInfo{
    _lightInfo = lightInfo;
    if (lightInfo) {
        for (int i = 0 ; i < 4; i++) {
            UIButton *btn = self.lightBtns[i];
            int hue  = [self.lightInfo.lights[i] intValue];
            UIColor *color = [UIColor colorWithHue:hue / 240.0 saturation:1 brightness:1 alpha:1];
            btn.backgroundColor = color;
            
            if (btn.isSelected) {
                //设置色环的颜色和角度
                self.indicatorView.color = color;
                //角度
                CGFloat roation = 2 *(M_PI) *(hue/240.0);
                self.indicatorView.transform = CGAffineTransformMakeRotation(roation);
            }
        }
    }
}
//上下
- (IBAction)updownClick:(id)sender {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        // Make all constraint changes here
        if (self.distanceCons.constant == -175) {
            self.distanceCons.constant = 0;
            self.updownBtn.transform =  CGAffineTransformMakeRotation(M_PI);
        }else{
            self.distanceCons.constant = -175;
            self.updownBtn.transform =  CGAffineTransformMakeRotation(0);
        }
      [self.view layoutIfNeeded];
    }];
    
    
}

-(void)setAlertModel:(BBAlertModel *)alertModel{
    _alertModel = alertModel;
    if (alertModel) {
        //设置开关
        [self.frontSwitch setOn:alertModel.openFrontLight];
        [self.stopSwitch setOn:alertModel.openStopLight];
        
    }
}
//前灯开关
- (IBAction)frontLightClick:(id)sender {
    self.alertModel.openFrontLight = self.frontSwitch.isOn;
    NSInteger value = (self.alertModel.lockAllowShutDown)*4 +
    (self.alertModel.lockAllowWarning)*8 +
    (self.alertModel.openFrontLight)*1 +
    (self.alertModel.openStopLight)*2 +
    (self.alertModel.backFastWarning)*16;
    [MainApi setAlertModelInfo:self.peripheral writeCharacteristic:self.writeCharacteristic DengGuanBao:(int)value];
    
}
//刹车灯开关
- (IBAction)shacheLightClick:(id)sender {
     self.alertModel.openStopLight = self.stopSwitch.isOn;
    NSInteger value = (self.alertModel.lockAllowShutDown)*4 +
    (self.alertModel.lockAllowWarning)*8 +
    (self.alertModel.openFrontLight)*1 +
    (self.alertModel.openStopLight)*2 +
    (self.alertModel.backFastWarning)*16;
    [MainApi setAlertModelInfo:self.peripheral writeCharacteristic:self.writeCharacteristic DengGuanBao:(int)value];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[BBLightFenWeiSettingVC class]]) {
        BBLightFenWeiSettingVC * vc = (BBLightFenWeiSettingVC *)segue.destinationViewController;
        vc.info = self.lightInfo;
    }
}

@end
