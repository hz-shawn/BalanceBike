//
//  BBBasicViewController.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/16.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBBasicViewController.h"
#import "AppDelegate.h"
@interface BBBasicViewController ()

@end

@implementation BBBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.baby = delegate.baby;
    self.peripheral = delegate.peripheral;
    self.writeCharacteristic = delegate.writeCharacteristic;
    self.readCharacteristic = delegate.readCharacteristic;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor, (__bridge id)[UIColor colorWithHex:0x4c4a48].CGColor, (__bridge id)[UIColor blackColor].CGColor];
    gradientLayer.locations = @[@0, @0.3, @0.7];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake( 0, 1);
    gradientLayer.frame = self.view.frame;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    
}


@end
