//
//  GGRegViewController.m
//  gogu04
//
//  Created by ren on 15/4/18.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGRegViewController.h"
#import "GoGuTool.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

@interface GGRegViewController ()
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *passwd;
@property (weak, nonatomic) IBOutlet UITextField *repeatpwd;
//@property (weak, nonatomic) IBOutlet UITextField *code;
- (IBAction)reg:(id)sender;

@end

@implementation GGRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)reg:(id)sender {
    
    GoGuTool *tool=[[GoGuTool alloc] init];
    
    if (![tool validateEmail:self.email.text]) {
        [MBProgressHUD showError:@"邮件格式错误～"];
    }else if (![self.passwd.text isEqualToString:self.repeatpwd.text]){
        [MBProgressHUD showError:@"两次输入密码不一致～"];
    }else{
        
        AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"email"] = self.email.text;
//        params[@"code"] = self.code.text;
        params[@"phone"] = self.phone.text;
        params[@"passwd"] = self.passwd.text;
        
        
        // 3.发送请求
        [mgr POST:REG_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSString *checkcode=responseObject[@"checkcode"];
            NSString *result=responseObject[@"result"];
//            if (![checkcode isEqualToString:@"ok"]) {
//                [MBProgressHUD showError:@"验证码错误"];
            if ([result isEqualToString:@"ok"]) {
                [MBProgressHUD showSuccess:@"用户创建成功～"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:@"用户创建失败失败"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络连接发生问题！"];
        }];

    }
    
}
@end
