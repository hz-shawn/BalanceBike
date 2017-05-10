//
//  YaoKongViewController.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/24.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "YaoKongViewController.h"
#import "JiantouView.h"

@interface YaoKongViewController ()
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *leftPowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxSpeedLabel;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@property (weak, nonatomic)  UIImageView *dian;
@property (strong,nonatomic) BBYKSpeed *speed;
@property (strong,nonatomic) BBYKInfo *info;
@property (strong,nonatomic) MainViewModel *viewModel;
@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) NSTimer *mainViewModelTimer;
@property (nonatomic,weak)   JiantouView *indicatorView ;
@property (weak, nonatomic) IBOutlet UILabel *danweiLabel;

@property (weak, nonatomic) IBOutlet UILabel *temLabel;


@end

@implementation YaoKongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *dian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dian_btn"]];
    dian.userInteractionEnabled = YES;
    dian.frame = CGRectMake(100, 100, 50, 50);
    self.dian = dian;
    [self.containerView addSubview:dian];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    [dian addGestureRecognizer:recognizer];
    self.speedLabel.font =  [UIFont fontWithName:@"Block Condensed" size:40];
    self.speedLabel.text = @"10.0 ";
    [self.timer fire];
    
    
    //增加箭头
    CGFloat width = 250 *0.5;
    CGFloat height = 20;
    
    JiantouView *view = [[JiantouView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    view.layer.anchorPoint = CGPointMake(0, 0.5);
    view.center = CGPointMake(width , width);
    [self.containerView addSubview:view];
    self.indicatorView = view;
    self.indicatorView.hidden = YES;
    
    self.title = @"蓝牙遥控";
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MainApi setYkModel:self.peripheral writeCharacteristic:self.writeCharacteristic]; //进入遥控模式
    [MainApi getYkStatus:self.peripheral writeCharacteristic:self.writeCharacteristic];//查询遥控信息
    [MainApi getYKXianSu:self.peripheral writeCharacteristic:self.writeCharacteristic]; //查询限速
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInfo:) name:BBYKSpeedInfoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getYKInfo:) name:BBYKInfoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSpeedInfo:) name:MainViewModelNotification object:nil];
    
    [self.mainViewModelTimer fire];
    
}
-(void)getInfo:(NSNotification *)notification{
    BBYKSpeed *model = (BBYKSpeed *)notification.object;
    self.speed = model;
}

-(void)getSpeedInfo:(NSNotification *)notification{
    MainViewModel *model = (MainViewModel *)notification.object;
    self.viewModel = model;
}


-(void)getYKInfo:(NSNotification *)notification{
    BBYKInfo *model = (BBYKInfo *)notification.object;
    self.info = model;
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];
    self.timer = nil;
    [self.mainViewModelTimer invalidate];
    _mainViewModelTimer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MainApi quiteYkModel:self.peripheral writeCharacteristic:self.writeCharacteristic];//退出遥控模式
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)swipe:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.indicatorView.hidden  = YES;
        self.dian.transform = CGAffineTransformIdentity;
        //设置00
        [MainApi setYkSpeed:self.peripheral writeCharacteristic:self.writeCharacteristic x:0 y:0];
        return;
    }
    self.indicatorView.hidden = NO;
    CGPoint point = [recognizer locationInView:self.containerView];
    CGFloat radius = 125;
    CGPoint p = [self getPoint:CGPointMake(radius, radius) endPoint:point radiu:radius - 25];
    self.dian.transform = CGAffineTransformMakeTranslation(p.x - radius, p.y-radius);
    
    
    CGPoint point1 = [recognizer locationInView:self.view];
    CGFloat roation = [self angleForStartPoint:self.containerView.center EndPoint:point1];
    self.indicatorView.transform = CGAffineTransformMakeRotation(roation);
    
    
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



-(CGPoint)getPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint  radiu:(CGFloat) r{
    
    CGFloat originX = startPoint.x;
    CGFloat originY = startPoint.y;
    CGFloat endX = endPoint.x;
    CGFloat endY = endPoint.y;
    CGFloat circleX = 0;
    CGFloat circleY = 0;
    CGFloat  y = endY - originY;
    CGFloat x = endX - originX;
    if (sqrt(x*x + y*y) < r) {
        return endPoint;
    }
    CGFloat ry =  y * r / sqrt(x*x + y*y);
    CGFloat rx = x *r / sqrt(x*x + y*y);
    circleX = rx +originX;
    circleY = ry + originY;
    return CGPointMake(circleX, circleY);
}

- (IBAction)sliderValueChange:(id)sender {
    if (isMi) {
        self.maxSpeedLabel.text = [NSString stringWithFormat:@"%.1fmph",toMi(self.speedSlider.value)];
    }else{
        self.maxSpeedLabel.text = [NSString stringWithFormat:@"%.1fKm/h",self.speedSlider.value];
    }
    
    //设置最大速度
    [MainApi setYKSpeed:self.peripheral writeCharacteristic:self.writeCharacteristic speed:self.speedSlider.value];
    [MainApi getYkStatus:self.peripheral writeCharacteristic:self.writeCharacteristic];
}


-(void)setSpeed:(BBYKSpeed *)speed{
    _speed = speed;
    if (speed) {
        if (isMi) {
            self.maxSpeedLabel.text =  [NSString stringWithFormat:@"%.1fmph",toMi(speed.speed)];
        }else{
            self.maxSpeedLabel.text =  [NSString stringWithFormat:@"%.1fKm/h",speed.speed];
        }
        
        self.speedSlider.value = speed.speed;
    }
}


-(void)setInfo:(BBYKInfo *)info{
    _info = info;
    if (info) {
        //设置速度
        if (isMi) {
            self.speedLabel.text = [NSString stringWithFormat:@"%.1f",toMi(info.KMH2 * 0.001)];
            self.danweiLabel.text = @"mph";
        }else{
            self.speedLabel.text = [NSString stringWithFormat:@"%.1f",info.KMH2 * 0.001];
            self.danweiLabel.text = @"Km/h";
        }
        
        self.leftPowerLabel.text = [NSString stringWithFormat:@"剩余电量:%d%%",info.ShengYuDianLiangBaiFe];
    }
}

-(void)setViewModel:(MainViewModel *)viewModel{
    _viewModel = viewModel;
    if (viewModel) {
        if (isMi) {
             self.speedLabel.text = [NSString stringWithFormat:@"%.1f ",toMi(viewModel.KMH2 * 0.001)];
            self.danweiLabel.text = @"mph";
            self.temLabel.text = [NSString stringWithFormat:@"车体温度:%.1f℉",viewModel.Temperature2 * 0.1*1.8 + 32];
        }else{
             self.speedLabel.text = [NSString stringWithFormat:@"%.1f ",viewModel.KMH2 * 0.001];
            self.danweiLabel.text = @"Km/h";
            self.temLabel.text = [NSString stringWithFormat:@"车体温度:%.1f℃",viewModel.Temperature2 * 0.1];
        }
       
        self.leftPowerLabel.text = [NSString stringWithFormat:@"剩余电量:%d%%",viewModel.ShengYuDianLiangBaiFenBi2];
        
        if (viewModel.zhanren || viewModel.lingqi) {
            [SVProgressHUD showInfoWithStatus:@"遥控模式下不能站人或拎起"];
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
    //            //计算xy
    CGFloat x = -((self.dian.transform.ty) * 0.01 * self.speed.speed * 1000);
    CGFloat y = -((self.dian.transform.tx) * 0.01 * self.speed.speed * 500);
    //设置速速
    [MainApi setYkSpeed:self.peripheral writeCharacteristic:self.writeCharacteristic x:x y:y];
}

-(NSTimer *)mainViewModelTimer{
    if (!_mainViewModelTimer) {
        _mainViewModelTimer =  [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(mainTimerLoop) userInfo:nil repeats:YES];
    }
    return _mainViewModelTimer;
}

-(void)mainTimerLoop{
    if(self.peripheral){
        
        [MainApi getMainInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];
    }else{
        [_mainViewModelTimer invalidate];
        _mainViewModelTimer = nil;
    }
}

@end
