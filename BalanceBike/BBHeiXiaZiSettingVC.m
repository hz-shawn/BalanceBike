//
//  BBHeiXiaZiSettingVC.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/15.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBHeiXiaZiSettingVC.h"
#import "BBHeiXiaZiCell.h"

@interface BBHeiXiaZiSettingVC () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *HXZList;
@property (assign,nonatomic) int begin;
@property (assign,nonatomic) BOOL flag;
@end

@implementation BBHeiXiaZiSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BBHeiXiaZiCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.flag = true;
    self.begin = 0x0400;
    
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"读取黑匣子需要锁车，是否继续？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.tag = 100;
    [alertView show];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInfo:) name:BBHXZInfoNotification object:nil];
}
-(void)getHeiXiaZiInfo{
    [MainApi getHeiXiaZiInfo:self.peripheral writeCharacteristic:self.writeCharacteristic index:self.begin];
}

-(void)jiesuo{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"黑匣子读取完成，是否解锁？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 200;
    [alertView show];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
//    [MainApi jiesuo:self.peripheral writeCharacteristic:self.writeCharacteristic];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)getInfo:(NSNotification *)notification{
     
    BBHeiXiaZiInfo *model = notification.object;
    if (model.code == 0xffff && model.errorCode == 0xffff) {
        
        [self performSelector:@selector(jiesuo) withObject:nil afterDelay:1];
        self.flag = false;
        return;
    }
    [self.HXZList addObject:model];
    [self.tableView reloadData];
    self.begin += 4;
    if (self.begin < 0x0C00) {
        [MainApi getHeiXiaZiInfo:self.peripheral writeCharacteristic:self.writeCharacteristic index:self.begin];
    }else{
        
        [self performSelector:@selector(jiesuo) withObject:nil afterDelay:1];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.HXZList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BBHeiXiaZiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.HXZList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSMutableArray *)HXZList{
    if (!_HXZList) {
        _HXZList = [NSMutableArray arrayWithCapacity:5];
    }
    return _HXZList;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        [MainApi suoche:self.peripheral writeCharacteristic:self.writeCharacteristic];
        [SVProgressHUD show];
        [self performSelector:@selector(getHeiXiaZiInfo) withObject:nil afterDelay:1];
    }
    if (alertView.tag == 200) {
        [SVProgressHUD dismiss];
        if (buttonIndex == 1) {
            [MainApi jiesuo:self.peripheral writeCharacteristic:self.writeCharacteristic ];
        }
    }
}
@end
