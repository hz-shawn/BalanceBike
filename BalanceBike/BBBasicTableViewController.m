//
//  BBBasicTableViewController.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/16.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBBasicTableViewController.h"
#import "AppDelegate.h"
@interface BBBasicTableViewController ()

@end

@implementation BBBasicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.baby = delegate.baby;
    self.peripheral = delegate.peripheral;
    self.writeCharacteristic = delegate.writeCharacteristic;
    self.readCharacteristic = delegate.readCharacteristic;
    
    self.view.backgroundColor = [UIColor blackColor];
 
 
    
}


@end
