//
//  BBBlueToothSettingVC.m
//  BalanceBike
//
//  Created by xuanxuan on 2017/3/15.
//  Copyright © 2017年 xuanxuan. All rights reserved.
//

#import "BBBlueToothSettingVC.h"

@interface BBBlueToothSettingVC () <UITextFieldDelegate, UIAlertViewDelegate>

@property (copy,nonatomic) NSString *name;
@property (copy,nonatomic) NSString *pwd;
@end

@implementation BBBlueToothSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getpwdInfo:) name:BBPWDInfoNotification object:nil];
}

-(void)getpwdInfo:(NSNotification *) notification{
    
    BBPwdInfo *model = (BBPwdInfo *)notification.object;
    NSLog(@"%@",model.pwd);
    if ([model.pwd isEqualToString:self.pwd]) {
        [self.baby cancelPeripheralConnection:self.peripheral];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        //设置蓝牙名称
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请设置蓝牙名称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *txtName = [alert textFieldAtIndex:0];
        //        txtName.keyboardType = UIKeyboardTypeASCIICapable;
        
        
        //        NSString * machineName =  [[NSUserDefaults standardUserDefaults] objectForKey:@"machineName"];
        //        if (machineName) {
        //            txtName.text = machineName;
        //        }else{
        txtName.text =  self.peripheral.name;
        //        }
        [alert show];
    }
    if(indexPath.row == 1){
        //设置密码
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请设置密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        UITextField *txtName = [alert textFieldAtIndex:0];
        txtName.keyboardType = UIKeyboardTypeNumberPad;
        txtName.placeholder = @"请设置6位数字密码";
        txtName.secureTextEntry = YES;
        
        UITextField *txtpwd = [alert textFieldAtIndex:1];
        txtpwd.keyboardType = UIKeyboardTypeNumberPad;
        txtpwd.placeholder = @"请再次输入密码";
         txtName.secureTextEntry = NO;
        
        [alert show];
    }
    
}

-(void)showSetPwdAlertView:(NSString *)title{
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput){
        //是设置密码
        if(buttonIndex ==0){
            return;
        }
        UITextField *txtName = [alertView textFieldAtIndex:0];
        UITextField *txtpwd = [alertView textFieldAtIndex:1];
        if(txtName.text.length != 6){
            [SVProgressHUD showErrorWithStatus:@"请设置6位密码"];
            return;
        }
        if (![txtName.text isEqualToString:txtpwd.text]){
            [SVProgressHUD showErrorWithStatus:@"两次密码不一致,请重新设置"];
            return;
        }
        self.pwd = txtpwd.text;
        [MainApi setpwdInfo:self.peripheral writeCharacteristic:self.writeCharacteristic pwd:txtpwd.text];
        
        [MainApi getPWDInfo:self.peripheral writeCharacteristic:self.writeCharacteristic];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changePwd" object:nil];
    }else{
        if (buttonIndex == 0) {
            return;
        }
        UITextField *txtName = [alertView textFieldAtIndex:0];
        NSData *data = [txtName.text dataUsingEncoding:NSUTF8StringEncoding];
        if (data.length > 30) {
            [SVProgressHUD showInfoWithStatus:@"名称不能超过30个字节"];
            return;
        }
        if (txtName.text.length ==0) {
            [SVProgressHUD showInfoWithStatus:@"名称不能为空"];
            return;
        }
        [txtName resignFirstResponder];
        
        [MainApi setMachineNameInfo:self.peripheral writeCharacteristic:self.writeCharacteristic name:data];
        //        [[NSUserDefaults standardUserDefaults] setObject:txtName.text forKey:@"machineName"];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
    }
    
}

- (BOOL)validate:(NSString *) textString
{
    NSString* number=@"^[0-9a-zA-Z]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

@end
