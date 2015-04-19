//
//  GGAdviceViewController.m
//  gogu04
//
//  Created by ren on 15/4/17.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGAdviceViewController.h"
#import "AFNetworking.h"
#import "GoGuTool.h"
#import "MBProgressHUD+MJ.h"

@interface GGAdviceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *advicetitle;
@property (weak, nonatomic) IBOutlet UITextField *advicecontent;
- (IBAction)sendAdv:(id)sender;

@end

@implementation GGAdviceViewController

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

- (IBAction)sendAdv:(id)sender {
    
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *uid=[defaults objectForKey:@"user_id"];
    NSString *token=[defaults objectForKey:@"token"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = uid;
    params[@"token"] = token;
    params[@"title"] = self.advicetitle.text;
    params[@"content"] = self.advicecontent.text;
    
    
    // 3.发送请求
    [mgr POST:NEW_ADVICE_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result=responseObject[@"result"];
        if ([result isEqualToString:@"ok"]) {
            [MBProgressHUD showSuccess:@"反馈意见已经发送"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [MBProgressHUD showError:@"发送失败！"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络连接发生问题！"];
    }];
    
    
}
@end
