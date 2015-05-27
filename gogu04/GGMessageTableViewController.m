//
//  GGMessageTableViewController.m
//  gogu04
//
//  Created by ren on 15/3/31.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGMessageTableViewController.h"
#import "HMCommonGroup.h"
#import "HMCommonItem.h"
#import "HMCommonCell.h"
#import "HMCommonArrowItem.h"
#import "HMCommonSwitchItem.h"
#import "HMCommonLabelItem.h"
#import "GGHomeTableViewController.h"
#import "GGChatTableViewController.h"

@interface GGMessageTableViewController ()
@property(strong,nonatomic) NSString *user_id;
@property(strong,nonatomic) NSString *token;
@end

@implementation GGMessageTableViewController

-(id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.user_id=[defaults objectForKey:@"user_id"];
    self.token=[defaults objectForKey:@"token"];
    
    
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
}

-(void)setupGroup0
{
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的基本数据
    //    group.header = @"第0组头部";
    //    group.footer = @"第0组尾部的详细信息";
    
    // 3.设置组的所有行数据
    HMCommonArrowItem *mymicroposts = [HMCommonArrowItem itemWithTitle:@"我的信息"];
//    username.subtitle=@"aaa";
    mymicroposts.operation= ^{
        GGHomeTableViewController *myVc=[[GGHomeTableViewController alloc] init];
        myVc.my_id=[NSNumber numberWithInt:[self.user_id intValue]];
        [self.navigationController pushViewController:myVc animated:YES];
    };
    //    username.text=@"aaaaaaaa";
    
    
    group.items = @[mymicroposts];
    
}


-(void)setupGroup1
{
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonArrowItem *replymicroposts = [HMCommonArrowItem itemWithTitle:@"回复信息"];
    replymicroposts.operation= ^{
        GGHomeTableViewController *replyVc=[[GGHomeTableViewController alloc] init];
        replyVc.my_reply_id=[NSNumber numberWithInt:[self.user_id intValue]];
        [self.navigationController pushViewController:replyVc animated:YES];
    };
//    advice.destVcClass=[GGAdviceViewController class];
    //    hotStatus.destVcClass = [HMOneViewController class];
    
    
    group.items = @[replymicroposts];
}

-(void)setupGroup2
{
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonArrowItem *chats = [HMCommonArrowItem itemWithTitle:@"我的私信"];
    chats.operation=^{
        GGChatTableViewController *chatVc=[[GGChatTableViewController alloc] init];
        [self.navigationController pushViewController:chatVc animated:YES];
    };
    
    
    
    group.items = @[chats];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
