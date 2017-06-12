//
//  MainViewController.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/5.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "MainViewController.h"
#import "MainSubViewController.h"
#import "BBEncypt.h"
#import "BBSystemInfo.h"
#import "MainViewModel.h"
#import "MainApi.h"
#import "AppDelegate.h"
#import "LimitSpeedModel.h"
#import "Const.h"
#import "SpeedView.h"
#define KTransformTime 1
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KsubTableViewHeight KScreenHeight
#define channelOnPeropheralView @"peripheralView"
#define KxiansuTag  101


@interface MainViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *contianerView;
@property (weak, nonatomic) IBOutlet UIButton *upDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *xiansuBtn;
@property (weak, nonatomic) IBOutlet UIButton *yaokongBtn;
@property (strong, nonatomic) UIView *subTableView;
@property (weak, nonatomic) IBOutlet UILabel *xiansuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *blueImageView;
@property (strong,nonatomic) NSMutableArray *services;
@property (strong,nonatomic) NSMutableArray *characteristics;
@property (strong,nonatomic) NSMutableArray *descriptors;
@property (strong,nonatomic) CBCharacteristic *readCharacteristic;
@property (strong,nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong,nonatomic) NSMutableArray *resultArray;
@property (strong,nonatomic) MainViewModel *mainViewModel;
@property (strong,nonatomic) LimitSpeedModel *limitSpeedModel;
@property (weak,nonatomic) MainSubViewController *subVC;
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong,nonatomic) BBSystemInfo *systemInfo;//设备信息

@property (strong,nonatomic) NSTimer *systemInfoTimer;//设备主要信息
@property (assign,nonatomic) NSInteger currentCount;//设备主要信息
@property (strong,nonatomic) NSTimer * mainViewModelTimer;//运行参数
@property (weak,nonatomic) SpeedView *speedView;
@end

@implementation MainViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contianerView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight * 1.5);
    self.contianerView.pagingEnabled = YES;
    self.contianerView.delegate = self;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor, (__bridge id)[UIColor colorWithHex:0x4c4a48].CGColor, (__bridge id)[UIColor blackColor].CGColor];
    gradientLayer.locations = @[@0, @0.3, @0.7];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake( 0, 1);
    gradientLayer.frame = self.view.frame;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    self.currentCount = 0;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.hidesBackButton =YES;
    
    //   NSString * machineName =  [[NSUserDefaults standardUserDefaults] objectForKey:@"machineName"];
    //    if (machineName) {
    //        self.title = machineName ;
    //    }else{
    self.title =  self.peripheral.name;
    //    }
    
    [self setupUI];
    [self babyDelegate];
    //    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    [self loadData];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.baby = self.baby;
    delegate.peripheral = self.peripheral;
    //显示loading
    self.activityIndicatorView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.activityIndicatorView.center=self.view.center;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicatorView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    //添加speedView
    SpeedView *speedView = [[SpeedView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width *0.5 - 100, 50, 200, 200)];
    self.speedView = speedView;
    speedView.speed = 0;
    speedView.power = 0;
    [self.contianerView addSubview:self.speedView];
    
    
    MainSubViewController *mainVC = (MainSubViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainSubViewController"];
    self.subVC = mainVC;
    self.subVC.baby = self.baby;
    self.subVC.peripheral = self.peripheral;
    self.subVC.containerView = self.contianerView;
    [self addChildViewController:mainVC];
    self.subTableView = mainVC.view;
    
    self.subTableView.frame = CGRectMake(0, KsubTableViewHeight - 264, self.contianerView.frame.size.width, KScreenHeight);
    [self.subVC.xuansuBtn addTarget:self action:@selector(xiansuClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.subVC.suoBtn addTarget:self action:@selector(updownClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.subVC.yaokongBtn addTarget:self action:@selector(yaokongClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contianerView addSubview:self.subTableView];
    [self.contianerView bringSubviewToFront:self.subTableView];
    [self.subTableView layoutSubviews];
    [self.contianerView layoutSubviews];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(changePwd) name:@"changePwd" object:nil];
}
-(void)changePwd{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:self.systemInfo.cardId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//#warning 这里需要注释掉
-(void)viewWillDisappear:(BOOL)animated{
    [self.mainViewModelTimer invalidate];
    [self.systemInfoTimer invalidate];
    _systemInfoTimer = nil;
    _mainViewModelTimer = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.systemInfo) {
        [self.mainViewModelTimer fire];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setupUI{
    //1.设置状态按钮
    self.statusBtn.layer.cornerRadius = 16;
    self.statusBtn.layer.masksToBounds = true;
    self.statusBtn.userInteractionEnabled = false;
    //2.初始化子tableView;
    
    
    
    
    //3.限速lable
    self.xiansuLabel.hidden = YES;
    
}


-(void)babyDelegate{
    
    __weak typeof(self)weakSelf = self;
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [self.baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@--连接成功",peripheral.name);
    }];
    //设置设备连接失败的委托
    [self.baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
    }];
    
    //设置设备断开连接的委托
    [self.baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        if ([peripheral.name isEqualToString:weakSelf.peripheral.name]) {
            //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"蓝牙断开连接" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //            alertView.tag = 100;
            //            [alertView show];
            
            [SVProgressHUD showErrorWithStatus:@"设备连接已断开"];
            //            [weakSelf.baby cancelAllPeripheralsConnection];
            [weakSelf.baby cancelPeripheralConnection:weakSelf.peripheral];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            
            
            
        }
    }];
    [self.baby setFilterOnConnectToPeripheralsAtChannel:channelOnPeropheralView filter:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        if ([peripheralName isEqualToString:weakSelf.peripheral.name]) {
            return YES;
        }
        return NO;
    }];
    
    //设置发现设备的Services的委托
    //    [self.baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
    //        for (CBService *service in peripheral.services) {
    //            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
    //        }
    //    }];
    
    [self.baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        weakSelf.peripheral = nil;
    }];
    
    //设置发现设service的Characteristics的委托
    [self.baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        NSString *uuid =  [NSString stringWithFormat:@"%@",service.UUID];
        if ([uuid rangeOfString:@"E0A9"].location != NSNotFound) {
            [weakSelf.services addObject:service];
            for (CBCharacteristic *c in service.characteristics) {
                NSLog(@"charateristic name is :%@",c.UUID);
                [weakSelf.characteristics addObject:c];
                NSString * property = [weakSelf readProperty:c];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                if([property containsString:@"Notify"]){
                    weakSelf.readCharacteristic = c;
                    delegate.readCharacteristic = c;
                }
                if ([property containsString:@"Write"]) {
                    weakSelf.writeCharacteristic = c;
                    delegate.writeCharacteristic = c;
                }
            }
        }
    }];
    //    //设置读取characteristics的委托
    //    [self.baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
    //         NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    //    }];
    
    //设置发现characteristics的descriptors的委托
    //    [self.baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
    //        NSLog(@"service name:%@",characteristic.service.UUID);
    //        for (CBDescriptor *d in characteristic.descriptors) {
    //            NSLog(@"------------CBDescriptor name is :%@",d.UUID);
    //        }
    //    }];
    //设置读取Descriptor的委托
    //    [self.baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
    //        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    //    }];
    
    //读取rssi的委托
    //    [self.baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
    //        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
    //    }];
    
    
    //设置beats break委托
    //    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
    //        NSLog(@"setBlockOnBeatsBreak call");
    //        //这里连接了蓝牙
    ////        [self.activityIndicatorView stopAnimating];
    ////        [self.systemInfoTimer fire];
    //
    //    }];
    
    //设置beats over委托
    //    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
    //        NSLog(@"setBlockOnBeatsOver call");
    //    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [self.baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    //设置写数据成功的block
    [self.baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        for(int i=0;i<[data length];i++)
            printf("testByteFF01[%d] = %x\n",i,resultByte[i]);
    }];
    
    //设置通知状态改变的block
    [self.baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnPeropheralView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
        [weakSelf.activityIndicatorView stopAnimating];
        [weakSelf.systemInfoTimer fire];
        
    }];
}

-(NSString *)readProperty:(CBCharacteristic *)characteristic{
    CBCharacteristicProperties p = characteristic.properties;
    NSString *text = @"";
    
    if (p & CBCharacteristicPropertyBroadcast) {
        text = [ text stringByAppendingString:@" | Broadcast"];
    }
    if (p & CBCharacteristicPropertyRead) {
        text = [ text stringByAppendingString:@" | Read"];
    }
    if (p & CBCharacteristicPropertyWriteWithoutResponse) {
        text = [ text stringByAppendingString:@" | WriteWithoutResponse"];
    }
    if (p & CBCharacteristicPropertyWrite) {
        text = [ text stringByAppendingString:@" | Write"];
    }
    if (p & CBCharacteristicPropertyNotify) {
        text = [ text stringByAppendingString:@" | Notify"];
    }
    if (p & CBCharacteristicPropertyIndicate) {
        text = [ text stringByAppendingString:@" | Indicate"];
    }
    if (p & CBCharacteristicPropertyAuthenticatedSignedWrites) {
        text = [ text stringByAppendingString:@" | AuthenticatedSignedWrites"];
    }
    if (p & CBCharacteristicPropertyExtendedProperties) {
        text = [ text stringByAppendingString:@" | ExtendedProperties"];
    }
    return text;
}

//订阅一个值
-(void)setNotifiy{
    if (self.readCharacteristic.properties & CBCharacteristicPropertyNotify ||  self.readCharacteristic.properties & CBCharacteristicPropertyIndicate) {
        
        if(self.readCharacteristic.isNotifying) {
            [self.baby cancelNotify:self.peripheral characteristic:self.readCharacteristic];
            
        }else{
            [self.peripheral setNotifyValue:YES forCharacteristic:self.readCharacteristic];
            
            [self.baby notify:self.peripheral
               characteristic:self.readCharacteristic
                        block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                            NSData * data = characteristics.value;
                            Byte * resultByte = (Byte *)[data bytes];
                            Byte *result = [BBEncypt unEncypt:resultByte count:[data length]];
                            for(int i=0;i<[data length];i++)
                                //                           printf("testByteFF02[%d] = %x\n",i,resultByte[i]);
                                //如果是55 aa 开头的 证明是返回值得开始
                                if ([data length] < 4) {
                                    return ;
                                }
                            if (result == NULL) {
                                return;
                            }
                            if (result[0] == 0x55 && result[1] ==0xaa ) {
                                [self.resultArray removeAllObjects];
                            }
                            for (int i = 0; i < [data length]; i++) {
                                [self.resultArray addObject:@(result[i])];
                            }
                            
                            //这里要校验了
                            int sum = 0;
                            if ([self.resultArray count] > 4) {
                                for (int i = 2; i < [self.resultArray count] - 2; i++) {
                                    sum += [self.resultArray[i] intValue];
                                }
                                int unsum = 0xffff ^ sum;
                                //                           NSLog(@"低位： 0x%x",(unsum & 0x00ff));
                                //                           NSLog(@"高位： 0x%x",(unsum & 0xff00) >> 8);
                                int lowBit = (unsum & 0x00ff);
                                int highBit = (unsum & 0xff00) >> 8;
                                //如果校验成功了
                                NSUInteger count = self.resultArray.count;
                                if (([self.resultArray.lastObject intValue] == highBit)  && ([self.resultArray[count-2] intValue] == lowBit)) {
                                    //这里找一个对象把数值给存起来
                                    if([self.resultArray[2] intValue] == 0x20){
                                        //蓝牙刚连接命令
                                        self.systemInfo = [[BBSystemInfo alloc]initWith:self.resultArray];
                                    }else if([self.resultArray[2] intValue] == 0x22){
                                        MainViewModel *mainViewModel = [[MainViewModel alloc]initWith:self.resultArray];
                                        self.mainViewModel = mainViewModel;
                                        [[NSNotificationCenter defaultCenter]postNotificationName:MainViewModelNotification object:mainViewModel];
                                    }else if([self.resultArray[2] intValue] == 0x06){
                                        LimitSpeedModel *model = [[LimitSpeedModel alloc]initWith:self.resultArray];
                                        self.limitSpeedModel = model;
                                        [[NSNotificationCenter defaultCenter]postNotificationName:LimitSpeedModelNotification object:model];
                                    }else if([self.resultArray[2] intValue] == 0x0C){
                                        BBSensorModel *model = [[BBSensorModel alloc]initWith:self.resultArray];
                                        [[NSNotificationCenter defaultCenter]postNotificationName:BBSensorModelNotification object:model];
                                    }else if([self.resultArray[2] intValue] == 0x18){
                                        BBBatteryInfo *model = [[BBBatteryInfo alloc]initWith:self.resultArray];
                                        [[NSNotificationCenter defaultCenter]postNotificationName:BBBatteryInfoNotification object:model];
                                    }else if([self.resultArray[2] intValue] == 0x04 && [self.resultArray[5] intValue] == 0xD3 ){
                                        BBAlertModel *model = [[BBAlertModel alloc]initWith:self.resultArray];
                                        [[NSNotificationCenter defaultCenter]postNotificationName:BBAlertInfoNotification object:model];
                                    }else if([self.resultArray[2] intValue] == 0x08){
                                        BBPwdInfo *model = [[BBPwdInfo alloc]initWith:self.resultArray];
                                        
                                        [[NSNotificationCenter defaultCenter]postNotificationName:BBPWDInfoNotification object:model];
                                    } else if([self.resultArray[2] intValue] == 0x0B){
                                        BBHeiXiaZiInfo *model = [[BBHeiXiaZiInfo alloc]initWith:self.resultArray];
                                        //                                   self.systemInfo.defaultBlePsw1 = model.pwd;
                                        [[NSNotificationCenter defaultCenter]postNotificationName:BBHXZInfoNotification object:model];
                                    }else if([self.resultArray[2] intValue] == 0x1C){
                                        BBLightInfo *model = [[BBLightInfo alloc]initWith:self.resultArray];
                                        [[NSNotificationCenter defaultCenter]postNotificationName:BBLightInfoNotification object:model];
                                    }else if([self.resultArray[2] intValue] == 0x04 && [self.resultArray[5] intValue] == 0x7D){
                                        BBYKSpeed *model = [[BBYKSpeed alloc]initWith:self.resultArray];
                                        [[NSNotificationCenter defaultCenter]postNotificationName:BBYKSpeedInfoNotification object:model];
                                    }else if([self.resultArray[2] intValue] == 0x0A){
                                        BBYKInfo *model = [[BBYKInfo alloc]initWith:self.resultArray];
                                        [[NSNotificationCenter defaultCenter]postNotificationName:BBYKInfoNotification object:model];
                                    }
                                    
                                }
                            }
                            
                            
                        }];
        }
    }
    
}




-(void)loadData{
    self.baby.having(self.peripheral).and.channel(channelOnPeropheralView).
    then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().begin();
}




#pragma MARK - 按钮点击事件
- (IBAction)xiansuClick:(id)sender {
    if (!self.mainViewModel.xiansu) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要切换为限速模式吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = KxiansuTag ;
        [alertView show];
        
    }else{
        [MainApi jieChuxiansu:self.peripheral writeCharacteristic:self.writeCharacteristic];
    }
    
}

- (IBAction)updownClick:(id)sender {
    
    if (self.mainViewModel.suoche) {
        [MainApi jiesuo:self.peripheral writeCharacteristic:self.writeCharacteristic];
    }else{
        [MainApi suoche:self.peripheral writeCharacteristic:self.writeCharacteristic];
    }
}



-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        
        self.subTableView.hidden =  false;
        
        [UIView animateWithDuration:KTransformTime animations:^{
            //container 透明度
            self.contianerView.alpha =  0 ;
            //箭头指向
            self.subTableView.frame = CGRectMake(0, 44,  self.contianerView.frame.size.width,  KsubTableViewHeight);
            self.subTableView.alpha = 1;
        } completion:^(BOOL finished) {
            
            
        }];
        
    }
}
- (IBAction)yaokongClick:(id)sender {
    if (self.mainViewModel.workmode2 != 0 && self.mainViewModel.workmode2 != 1) {
        [SVProgressHUD showInfoWithStatus:@"当前模式不是待机或者助力模式"];
        [MainApi quiteYkModel:self.peripheral writeCharacteristic:self.writeCharacteristic];
        return;
    }
    [self performSegueWithIdentifier:@"yaokong" sender:nil];
    
}

-(void)setMainViewModel:(MainViewModel *)mainViewModel{
    _mainViewModel = mainViewModel;
    self.subVC.viewModel = mainViewModel;
    if (mainViewModel.wangning2 != 0) {
        [SVProgressHUD showInfoWithStatus:@"小心骑行,注意安全"];
    }
    
    if(mainViewModel.errCode2 != 0){
        //        [SVProgressHUD showInfoWithStatus:@"车辆故障，请及时维修"];
        [self.statusBtn setTitle:@"   车辆故障，请及时维修  " forState:UIControlStateNormal];
    }else{
        [self.statusBtn setTitle:@"   车辆运行正常   " forState:UIControlStateNormal];
        
    }
    
    
    if (mainViewModel.xiansu) {
        self.xiansuBtn.selected = YES;
        self.subVC.xuansuBtn.selected = YES;
        self.xiansuLabel.text = @"限速模式";
    }else{
        self.xiansuBtn.selected = NO;
        self.subVC.xuansuBtn.selected = NO;
    }
    
    if (mainViewModel.suoche) {
        self.upDownBtn.selected = YES;
        self.subVC.suoBtn.selected = YES;
        self.xiansuLabel.text = @"锁车模式";
    }else{
        self.upDownBtn.selected = NO;
        self.subVC.suoBtn.selected = NO;
    }
    
    self.xiansuLabel.hidden = !(mainViewModel.suoche || mainViewModel.xiansu);
    
    
    
    self.speedView.maxSpeed = 20;
    self.speedView.speed = mainViewModel.KMH2 * 0.001;
    self.speedView.power = mainViewModel.ShengYuDianLiangBaiFenBi2 * 0.01;
 
}


-(void)setLimitSpeedModel:(LimitSpeedModel *)limitSpeedModel{
    
        _limitSpeedModel = limitSpeedModel;
        self.speedView.totalKm = limitSpeedModel.XianSuSet * 0.001; //限速值
    
}

-(NSMutableArray *)services{
    if (!_services) {
        _services = [NSMutableArray arrayWithCapacity:2];
    }
    return _services;
}
-(NSMutableArray *)characteristics{
    if (!_characteristics) {
        _characteristics = [NSMutableArray arrayWithCapacity:2];
    }
    return _characteristics;
}
-(NSMutableArray *)descriptors{
    if(!_descriptors){
        _descriptors = [NSMutableArray arrayWithCapacity:2];
    }
    return _descriptors;
}

-(void)setReadCharacteristic:(CBCharacteristic *)readCharacteristic{
    _readCharacteristic = readCharacteristic;
    if (_readCharacteristic) {
        [self setNotifiy];
    }
}

-(NSMutableArray *)resultArray{
    if (!_resultArray) {
        _resultArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _resultArray;
}

-(void)setSystemInfo:(BBSystemInfo *)systemInfo{
    if (_systemInfo) {
        return;
    }
    _systemInfo = systemInfo;
    if(systemInfo){
        //1.关闭定时器
        [self.systemInfoTimer invalidate];
        self.systemInfoTimer = nil;
        //2.判断是不是设置了密码 没有设置密码则需要设置密码
        if ([systemInfo.defaultBlePsw1 isEqualToString:@"000000"]) {
            //这时候没有设置密码 进入主界面
            
            [self.mainViewModelTimer fire];
//            [self showSetPwdAlertView:@"请设置6位初始密码"];
        }else{
            //去本地查找密码
            //如果不对 或者 没有 则需要重新输入
            NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:systemInfo.cardId];
            if([pwd isEqualToString:systemInfo.defaultBlePsw1]){
                //进入主界面
                [self.mainViewModelTimer fire];
            }else{
                [self showSetPwdAlertView:@"请输入密码"];
            }
        }
    }
}


-(void)showSetPwdAlertView:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.keyboardType = UIKeyboardTypeNumberPad;
    txtName.placeholder = @"请输入6位数字密码";
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        //        [self.baby cancelAllPeripheralsConnection];
        [self.baby cancelPeripheralConnection:self.peripheral];
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.peripheral = nil;
        return;
    }
    if (alertView.tag == KxiansuTag) {
        //限速
        if(buttonIndex == 1){
            [MainApi xiansu:self.peripheral writeCharacteristic:self.writeCharacteristic];
            
        }
        return;
    }
    //设置初始化按钮
    if(buttonIndex == 0){
        //        [self.baby cancelAllPeripheralsConnection];
        [self.baby cancelPeripheralConnection:self.peripheral];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UITextField *txtName = [alertView textFieldAtIndex:0];
    if([self.systemInfo.defaultBlePsw1 isEqualToString:@"000000"]){
        
        if (txtName.text.length != 6) {
            [self showSetPwdAlertView:@"请设置6位初始密码"];
        }else{
            //设置密码
            [MainApi setpwdInfo:self.peripheral writeCharacteristic:self.writeCharacteristic pwd:txtName.text];
            self.systemInfo.defaultBlePsw1 = txtName.text;
        }
    }else{
        //判读输入的密码是不是和蓝牙密码一样的
        if([txtName.text isEqualToString:self.systemInfo.defaultBlePsw1]){
            [[NSUserDefaults standardUserDefaults] setObject:self.systemInfo.defaultBlePsw1 forKey:self.systemInfo.cardId];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //进入主界面
            [self.mainViewModelTimer fire];
        }else{
            [SVProgressHUD showErrorWithStatus:@"密码不正确"];
            
            [self.baby cancelPeripheralConnection:self.peripheral];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    
    
}

-(NSTimer *)mainViewModelTimer{
    if (!_mainViewModelTimer) {
        _mainViewModelTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(mainTimerLoop) userInfo:nil repeats:YES];
    }
    return _mainViewModelTimer;
}

-(void)mainTimerLoop{
    if(self.peripheral){
        if (self.writeCharacteristic) {
            [MainApi getMainInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];
            [MainApi getLimitSpeedInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];
        }
    }else{
        [_mainViewModelTimer invalidate];
        _mainViewModelTimer = nil;
    }
}

-(NSTimer *)systemInfoTimer{
    if (!_systemInfoTimer) {
        _systemInfoTimer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(systemTimerLoop) userInfo:nil repeats:YES];
    }
    return _systemInfoTimer;
}


-(void)systemTimerLoop{
    self.currentCount = self.currentCount + 1;
    if (self.peripheral) {
        if (self.writeCharacteristic) {
            [MainApi getSystemInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];
        }
        
    }else{
        [_systemInfoTimer isValid];
        _systemInfoTimer = nil;
    }
    
}

-(void)setCurrentCount:(NSInteger)currentCount{
    _currentCount = currentCount;
    if (currentCount >= 25) {
        [self.systemInfoTimer invalidate];
        self.systemInfoTimer = nil;
        [SVProgressHUD showErrorWithStatus:@"该设备无法连接"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //判断scrollview滑动
    self.speedView.alpha = (200 - scrollView.contentOffset.y )/200 > 0 ?  (200 - scrollView.contentOffset.y )/200 : 0;
    self.statusBtn.alpha = (200 - scrollView.contentOffset.y )/200 > 0 ?  (200 - scrollView.contentOffset.y )/200 : 0;
    self.xiansuLabel.alpha = (200 - scrollView.contentOffset.y )/200 > 0 ?  (200 - scrollView.contentOffset.y )/200 : 0;
    self.blueImageView.alpha = (200 - scrollView.contentOffset.y )/200 > 0 ?  (200 - scrollView.contentOffset.y )/200 : 0;
    
    self.subVC.currentSpeedLabel.alpha = scrollView.contentOffset.y / 200;
    self.subVC.danweiLabel.alpha =  scrollView.contentOffset.y / 200;
}
@end
