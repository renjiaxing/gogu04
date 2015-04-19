//
//  GGForgetPwdViewController.m
//  gogu04
//
//  Created by ren on 15/4/18.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGForgetPwdViewController.h"
#import "GoGuTool.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

@interface GGForgetPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *email;
- (IBAction)sendReq:(id)sender;

@end

@implementation GGForgetPwdViewController

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

- (IBAction)sendReq:(id)sender {
    
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    
    params[@"email"] = self.email.text;
    
    
    // 3.发送请求
    [mgr GET:FORGET_PASSWORD_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result=responseObject[@"result"];
        if ([result isEqualToString:@"ok"]) {
            [MBProgressHUD showSuccess:@"请登录邮箱重置密码～"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"邮箱输入有误，请重新输入～"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络连接发生问题！"];
    }];

}
@end
