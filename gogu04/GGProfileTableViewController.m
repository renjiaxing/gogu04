//
//  GGProfileTableViewController.m
//  gogu04
//
//  Created by ren on 15/4/15.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGProfileTableViewController.h"
#import "HMCommonGroup.h"
#import "HMCommonItem.h"
#import "HMCommonCell.h"
#import "HMCommonArrowItem.h"
#import "HMCommonSwitchItem.h"
#import "HMCommonLabelItem.h"
#import "GGAdviceViewController.h"
#import "GGChangePwdViewController.h"
#import "GGLoginViewController.h"

@interface GGProfileTableViewController ()

@end

@implementation GGProfileTableViewController

-(id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {

    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
}

-(void)setupGroup0
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的基本数据
//    group.header = @"第0组头部";
//    group.footer = @"第0组尾部的详细信息";
    
    // 3.设置组的所有行数据
    HMCommonItem *username = [HMCommonItem itemWithTitle:@"用户名"];
    username.subtitle=[defaults objectForKey:@"username"];
//    hotStatus.destVcClass = [HMOneViewController class];
//    username.text=@"aaaaaaaa";
    
    
    group.items = @[username];
    
}

-(void)setupGroup3
{
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonItem *logout = [HMCommonItem itemWithTitle:@"退出登录"];
    //    hotStatus.destVcClass = [HMOneViewController class];
    logout.operation= ^{
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSDictionary *dic=[defaults dictionaryRepresentation];
        for(NSString *key in [dic allKeys])
        {
            [defaults removeObjectForKey:key];
            [defaults synchronize];
        }
        
        UIWindow *frontWindow=[[UIApplication sharedApplication] keyWindow];

        GGLoginViewController *loginVc=[[GGLoginViewController alloc] init];
        UINavigationController *loginNav=[[UINavigationController alloc] initWithRootViewController:loginVc];
        frontWindow.rootViewController=loginNav;

    };

    
    
    group.items = @[logout];
    
}

-(void)setupGroup1
{
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonArrowItem *advice = [HMCommonArrowItem itemWithTitle:@"意见反馈"];
    advice.destVcClass=[GGAdviceViewController class];
//    hotStatus.destVcClass = [HMOneViewController class];
    
    
    group.items = @[advice];
}

-(void)setupGroup2
{
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonArrowItem *changepwd = [HMCommonArrowItem itemWithTitle:@"修改密码"];
    changepwd.destVcClass=[GGChangePwdViewController class];
    //    hotStatus.destVcClass = [HMOneViewController class];
    
    
    group.items = @[changepwd];
}



@end
