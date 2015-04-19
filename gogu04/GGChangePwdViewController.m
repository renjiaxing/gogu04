//
//  GGChangePwdViewController.m
//  gogu04
//
//  Created by ren on 15/4/17.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGChangePwdViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "GoGuTool.h"


@interface GGChangePwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldpwd;
@property (weak, nonatomic) IBOutlet UITextField *newpwd;
@property (weak, nonatomic) IBOutlet UITextField *repeatnewpwd;

- (IBAction)change:(id)sender;
@end

@implementation GGChangePwdViewController

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

- (IBAction)change:(id)sender {
    if (![self.newpwd.text isEqualToString:self.repeatnewpwd.text]) {
        [MBProgressHUD showError:@"两次输入密码不一致～"];
    }else if ([self.newpwd.text isEqualToString:@""]){
        [MBProgressHUD showError:@"密码不能为空～"];
    }else{
        
        AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *uid=[defaults objectForKey:@"user_id"];
        NSString *token=[defaults objectForKey:@"token"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"uid"] = uid;
        params[@"token"] = token;
        params[@"oldpwd"] = self.oldpwd.text;
        params[@"newpwd"] = self.newpwd.text;
        
        
        // 3.发送请求
        [mgr POST:CHANGE_PASSWORD_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *result=responseObject[@"result"];
            if ([result isEqualToString:@"ok"]) {
                [MBProgressHUD showSuccess:@"密码修改成功～"];
                [self.navigationController popViewControllerAnimated:YES];
            }else if ([result isEqualToString:@"pwdnook"]){
                [MBProgressHUD showError:@"旧密码错误！"];
            }else{
                [MBProgressHUD showError:@"密码修改失败"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络连接发生问题！"];
        }];

    }
    
}
@end
