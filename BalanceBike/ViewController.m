//
//  ViewController.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/2/28.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "ViewController.h"
#import "BabyBluetooth.h"
#import "PeripheralTableViewCell.h"
#import "MainViewController.h"

#define kSearchTime 10 //搜索时间
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (assign,nonatomic) BOOL isSearching;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
@property (strong,nonatomic) BabyBluetooth *baby;
@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) NSMutableArray<CBPeripheral *> *peripherals;
@property (strong,nonatomic) UITableView *tableView;
@property (copy,nonatomic) NSString *machineName;
@property (copy,nonatomic) NSString *oldmachineName;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.navigationController.navigationBarHidden = YES;
    
    //设置导航栏透明
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    //设置主体颜色
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
 
    
    self.title = @"搜索结果";
    self.isSearching = false;
    [self setupUI];
    [self babyDelegate];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor, (__bridge id)[UIColor colorWithHex:0x4c4a48].CGColor, (__bridge id)[UIColor blackColor].CGColor];
    gradientLayer.locations = @[@0, @0.3, @0.7];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake( 0, 1);
    gradientLayer.frame = self.view.frame;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.baby cancelAllPeripheralsConnection];
    [self.peripherals removeAllObjects];
    [self.tableView reloadData];
    [self searchBtnClick:nil];
    
    self.machineName =  [[NSUserDefaults standardUserDefaults] objectForKey:@"machineName"];
    self.oldmachineName =  [[NSUserDefaults standardUserDefaults] objectForKey:@"machineOldName"];
}
-(void)babyDelegate{
    __weak typeof(self) weakSelf = self;
    [self.baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            NSLog(@"设备打开成功，开始扫描设备");
            //            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }
    }];
    
    [self.baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        if(![weakSelf.peripherals containsObject:peripheral]){
            if (peripheral.name.length > 0) {
                [weakSelf.peripherals addObject:peripheral];
                [weakSelf.tableView reloadData];
            }
        }
        weakSelf.isSearching = false;
    }];
}


-(void)setupUI{
    //1.搜索按钮
    self.searchBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchBtn.layer.borderWidth = 1.0f;
    self.searchBtn.layer.cornerRadius = 20;
    self.searchBtn.layer.masksToBounds = YES;
    
    //2.搜索图标
    self.searchImageView.hidden = YES;
    self.searchLabel.hidden = YES;
    
    //3.设置搜搜结果页面
    self.tableView.dataSource = self;
    self.tableView.delegate =  self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"PeripheralTableViewCell" bundle:nil] forCellReuseIdentifier:@"PeripheralTableViewCell"];
    [self.view addSubview:_tableView];
}

#pragma mark -开始动画
-(void)startAnimation{
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue =  [NSNumber numberWithFloat:0];
    animation.toValue =  [NSNumber numberWithFloat:M_PI *2];
    animation.duration  = 3;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = 500;
    [self.searchImageView.layer addAnimation:animation forKey:@"rotaion"];
}

#pragma mark -停止动画
-(void)stopAnimation{
    [self.searchImageView.layer removeAnimationForKey:@"rotaion"];
}

- (IBAction)searchBtnClick:(id)sender {
//    if (sender) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"需要进入重新搜索吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//        [alert show];
//    }else{
        [self search];
//    }
    
}


-(void)search{
    self.isSearching = !self.isSearching;
    if(self.isSearching){//开始搜索
        [self.peripherals removeAllObjects];
        self.baby.scanForPeripherals().begin().stop(kSearchTime);
        [self addTimer];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self search];
    }
}

-(void)setIsSearching:(BOOL)isSearching{
    _isSearching = isSearching;
    dispatch_async(dispatch_get_main_queue(), ^{
        if( _isSearching){
            [self.peripherals removeAllObjects];
            self.searchImageView.hidden = false;
            self.searchLabel.hidden = false;
            self.searchImageView.image = [UIImage imageNamed:@"device_searching"];
            self.searchLabel.text = @"正在搜索蓝牙设备";
            self.searchBtn.hidden = YES;
            [self startAnimation];
            
        }else{
            [self  stopAnimation];
            self.searchBtn.hidden = false;
            [self.searchBtn setTitle:@"重新搜索" forState:UIControlStateNormal];
            if (self.peripherals.count) {
                self.searchImageView.hidden = YES;
                self.searchLabel.hidden = YES;
            }else{
                self.searchImageView.image = [UIImage imageNamed:@"bar_close"];
                self.searchLabel.text = @"未搜索到蓝牙设备";
            }
        }
    });
    
    
}

-(BabyBluetooth *)baby{
    if(!_baby){
        _baby = [BabyBluetooth shareBabyBluetooth];
    }
    return _baby;
}

-(NSTimer *)addTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer =  [NSTimer scheduledTimerWithTimeInterval:kSearchTime target:self selector:@selector(stopSearch) userInfo:nil repeats:NO];
    return _timer;
}
-(void)stopSearch{
    
    self.isSearching = false;
}



-(NSMutableArray<CBPeripheral *> *)peripherals{
    if (!_peripherals) {
        _peripherals = [NSMutableArray arrayWithCapacity:5];
    }
    return _peripherals;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 144) style:UITableViewStylePlain];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _peripherals.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PeripheralTableViewCell *cell = (PeripheralTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PeripheralTableViewCell" forIndexPath:indexPath];
    CBPeripheral * peripheral = self.peripherals[indexPath.row];
    cell.machineName = self.machineName;
    cell.oldmachineName = self.oldmachineName;
//    if ([self.oldmachineName isEqualToString:peripheral.name]) {
//        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
//    }
    cell.peripheral = peripheral;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        CBPeripheral * peripheral = self.peripherals[indexPath.row];
    if (peripheral.name.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:peripheral.name forKey:@"machineOldName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"showMainViewController" sender:indexPath];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[MainViewController class]] ) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        MainViewController *vc = (MainViewController *)segue.destinationViewController;
        vc.peripheral = self.peripherals[indexPath.row];
        vc.baby = self.baby;
    }
}

@end
