//
//  GGPushSettingsController.m
//  gogu04
//
//  Created by 任佳星 on 15/6/14.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGPushSettingsController.h"
#import "AFNetworking.h"
#import "GoGuTool.h"
#import "MBProgressHUD+MJ.h"
#import "GGPushTableViewCell.h"

@interface GGPushSettingsController () <GGPushTableViewCellDelegate>
@property(nonatomic,copy) NSString *user_id;
@property(nonatomic,copy) NSString *token;
@property(nonatomic,strong) NSString *apple_micro_push;
@property(nonatomic,strong) NSString *apple_reply_push;
@property(nonatomic,strong) NSString *apple_chat_push;
@end

@implementation GGPushSettingsController

//-(id)init
//{
//    return [self initWithStyle:UITableViewStyleGrouped];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.user_id=[defaults objectForKey:@"user_id"];
    self.token=[defaults objectForKey:@"token"];
    self.apple_micro_push=[defaults objectForKey:@"apple_micro_push"];
    self.apple_reply_push=[defaults objectForKey:@"apple_reply_push"];
    self.apple_chat_push=[defaults objectForKey:@"apple_chat_push"];
    
    
    self.tableView.backgroundColor = HWColor(235,235,241);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = 5;
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    UINib *nib=[UINib nibWithNibName:@"GGPushTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"GGPushTableViewCell"];
    
    if (self.apple_micro_push==nil) {
        self.apple_micro_push=@"true";
    }
    if (self.apple_chat_push==nil) {
        self.apple_chat_push=@"true";
    }
    
    if (self.apple_reply_push==nil) {
        self.apple_reply_push=@"true";
    }

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    
    [manager GET:MY_PUSH_INFO_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.apple_chat_push=responseObject[@"apple_chat_push"];
        self.apple_reply_push=responseObject[@"apple_reply_push"];
        self.apple_micro_push=responseObject[@"apple_micro_push"];
        
        [defaults setObject:@"apple_chat_push" forKey:self.apple_chat_push];
        [defaults setObject:@"apple_micro_push" forKey:self.apple_micro_push];
        [defaults setObject:@"apple_reply_push" forKey:self.apple_reply_push];
        
        [defaults synchronize];
        
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络问题，加载失败～"];
    }];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGPushTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGPushTableViewCell" forIndexPath:indexPath];
    
    if (indexPath.section==0) {
        cell.pushLabel.text=@"我的信息被回复后推送";
        if ([self.apple_micro_push isEqualToString:@"true"]) {
            cell.pSwitch.on=YES;
        }else{
            cell.pSwitch.on=NO;
        }
        cell.tag=0;
    }
    
    if (indexPath.section==1) {
        cell.pushLabel.text=@"我回复的信息被回复后推送";
        if ([self.apple_reply_push isEqualToString:@"true"]) {
            cell.pSwitch.on=YES;
        }else{
            cell.pSwitch.on=NO;
        }
        cell.tag=1;
    }
    
    if (indexPath.section==2) {
        cell.pushLabel.text=@"我的新私信";
        if ([self.apple_chat_push isEqualToString:@"true"]) {
            cell.pSwitch.on=YES;
        }else{
            cell.pSwitch.on=NO;
        }
        cell.tag=2;
    }
    
    cell.delegate=self;
    
    return cell;
}

-(void)clickPush:(GGPushTableViewCell *)cell
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    
    NSString *clickUrl=ACTIVE_APPLE_MICRO_PUSH_URL;
    
    if (cell.tag==0) {
        clickUrl=ACTIVE_APPLE_MICRO_PUSH_URL;
    }else if (cell.tag==1){
        clickUrl=ACTIVE_APPLE_REPLY_PUSH_URL;
    }else{
        clickUrl=ACTIVE_APPLE_CHAT_PUSH_URL;
    }
    
    [manager POST:clickUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![responseObject[@"result"] isEqualToString:@"ok"]) {
//            if (cell.tag==0) {
//                cell.pSwitch.on=NO;
//            }else if (cell.tag==1){
//                cell.pSwitch.on=NO;
//            }else{
//                cell.pSwitch.on=NO;
//            }
            [MBProgressHUD showError:@"设置失败，请稍后重试~"];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络问题，加载失败～"];
    }];
}

-(void)clickNotPush:(GGPushTableViewCell *)cell
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    
    NSString *clickUrl=DEACTIVE_APPLE_MICRO_PUSH_URL;
    
    if (cell.tag==0) {
        clickUrl=DEACTIVE_APPLE_MICRO_PUSH_URL;
    }else if (cell.tag==1){
        clickUrl=DEACTIVE_APPLE_REPLY_PUSH_URL;
    }else{
        clickUrl=DEACTIVE_APPLE_CHAT_PUSH_URL;
    }
    
    [manager POST:clickUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (![responseObject[@"result"] isEqualToString:@"ok"]) {
//            if (cell.tag==0) {
//                cell.pSwitch.on=YES;
//            }else if (cell.tag==1){
//                cell.pSwitch.on=YES;
//            }else{
//                cell.pSwitch.on=YES;
//            }
            [MBProgressHUD showError:@"设置失败，请稍后重试~"];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络问题，加载失败～"];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
