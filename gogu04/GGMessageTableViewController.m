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
#import "GGMyStockTableViewController.h"
#import "AFNetworking.h"
#import "GoGuTool.h"
#import "RKNotificationHub.h"

@interface GGMessageTableViewController ()
@property(strong,nonatomic) NSString *user_id;
@property(strong,nonatomic) NSString *token;
@property(strong,nonatomic) NSString *myunread;
@property(strong,nonatomic) NSString *replyunread;
@property(strong,nonatomic) NSString *msgunread;
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
    
//    self.view.backgroundColor=[UIColor whiteColor];


//    RKNotificationHub* hub1 = [[RKNotificationHub alloc]initWithView:((HMCommonArrowItem *)((HMCommonGroup *)self.groups[0]).items[0]).title];
//    [hub1 increment];

    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];

}

-(void)viewWillAppear:(BOOL)animated
{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    
    [manager GET:MICROPOSTS_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        UITabBarItem *item=self.tabBarItem;
        
        int unRead=[responseObject[@"unreadnum"] intValue]+[responseObject[@"unreadmicro"] intValue]+[responseObject[@"unreplymicro"] intValue];
        self.myunread=[responseObject[@"unreadmicro"] stringValue];
        self.replyunread=[responseObject[@"unreplymicro"] stringValue];
        self.msgunread=[responseObject[@"unreadnum"] stringValue];
        
        HMCommonArrowItem *myunread=((HMCommonGroup *)self.groups[0]).items[0];
        
        if ([self.myunread isEqualToString:@"0"]) {
            myunread.badgeValue=nil;
        }else{
            myunread.badgeValue=self.myunread;
        }
        
        HMCommonArrowItem *replyunread=((HMCommonGroup *)self.groups[1]).items[0];
        
        if ([self.replyunread isEqualToString:@"0"]) {
            replyunread.badgeValue=nil;
        }else{
            replyunread.badgeValue=self.replyunread;
        }
        
        HMCommonArrowItem *msgunread=((HMCommonGroup *)self.groups[2]).items[0];
        
        if ([self.msgunread isEqualToString:@"0"]) {
            msgunread.badgeValue=nil;
        }else{
            msgunread.badgeValue=self.msgunread;
        }
        
        
        if (unRead==0) {
            item.badgeValue=nil;
        }else{
            item.badgeValue=[NSString stringWithFormat:@"%d",unRead];
        }
        
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
        
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
    mymicroposts.badgeValue=self.myunread;
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
//    replymicroposts.badgeValue=self.replyunread;
    
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
    
//    chats.badgeValue=self.msgunread;
    
    chats.operation=^{
        GGChatTableViewController *chatVc=[[GGChatTableViewController alloc] init];
        [self.navigationController pushViewController:chatVc animated:YES];
    };
    
    
    
    group.items = @[chats];
}


-(void)setupGroup3
{
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    HMCommonArrowItem *addstock = [HMCommonArrowItem itemWithTitle:@"关注股票"];
    addstock.destVcClass=[GGMyStockTableViewController class];
    //    hotStatus.destVcClass = [HMOneViewController class];
    
    
    group.items = @[addstock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
