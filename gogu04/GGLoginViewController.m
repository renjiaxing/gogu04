//
//  GGLoginViewController.m
//  gogu04
//
//  Created by ren on 15/4/1.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGLoginViewController.h"
#import "AFNetworking.h"
#import "GoGuTool.h"
#import "GGTabBarViewController.h"
#import "MBProgressHUD+MJ.h"
#import "GGRegViewController.h"
#import "GGForgetPwdViewController.h"
#import "XGPush.h"

@interface GGLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
- (IBAction)login:(id)sender;
- (IBAction)reg:(id)sender;
- (IBAction)forgetpwd:(id)sender;


@end

@implementation GGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"股刺登陆";
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

- (IBAction)login:(id)sender {
    

    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    // AFN的AFJSONResponseSerializer默认不接受text/plain这种类型
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] =self.userName.text;
    params[@"passwd"] = self.passWord.text;

    
    // 3.发送请求
    [mgr GET:LOGIN_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result=responseObject[@"result"];
        if ([result isEqualToString:@"ok"]) {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:responseObject[@"user_id"] forKey:@"user_id"];
            [defaults setObject:responseObject[@"token"] forKey:@"token"];
            [defaults setObject:self.userName.text forKey:@"username"];
            [defaults synchronize];
            [XGPush setAccount:[NSString stringWithFormat:@"account%@",responseObject[@"user_id"]]];
            
            void (^successBlock)(void) = ^(void){
                //成功之后的处理
                NSLog(@"[XGPush]register successBlock");
            };
            
            void (^errorBlock)(void) = ^(void){
                //失败之后的处理
                NSLog(@"[XGPush]register errorBlock");
            };
            
            //注册设备
            //    [[XGSetting getInstance] setChannel:@"appstore"];
            //    [[XGSetting getInstance] setGameServer:@"巨神峰"];
            
            NSData *deviceToken=[defaults objectForKey:@"deviceToken"];
            NSLog(@"%@",deviceToken);
            
            if (deviceToken!=nil) {
                NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
                
                
                NSLog(@"deviceTokenStr is %@",deviceTokenStr);
            }

            
            UIWindow *frontWindow=[[UIApplication sharedApplication] keyWindow];
            frontWindow.rootViewController=[[GGTabBarViewController alloc] init];
        }else{
            [MBProgressHUD showError:@"用户名和密码错误！"];
            self.userName.text=@"";
            self.passWord.text=@"";
            [self.userName becomeFirstResponder];
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络连接发生问题！"];
        NSLog(@"Error: %@", error);
    }];


}

- (IBAction)reg:(id)sender {
    
    GGRegViewController *regVc=[[GGRegViewController alloc] init];
    [self.navigationController pushViewController:regVc animated:YES];
}

- (IBAction)forgetpwd:(id)sender {
    
    GGForgetPwdViewController *forgetVc=[[GGForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:forgetVc animated:YES];
}


@end
