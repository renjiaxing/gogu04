//
//  GGChatTableViewController.m
//  gogu04
//
//  Created by ren on 15/5/23.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGChatTableViewController.h"
#import "GGChatTableViewCell.h"
#import "AFNetworking.h"
#import "GoGuTool.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "Mymessage.h"
#import "MBProgressHUD+MJ.h"
#import "GGNewMessageTableViewController.h"
#import "GGNavigationController.h"
#import "RKNotificationHub.h"

@interface GGChatTableViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSMutableArray *mymessageArray;
@property(nonatomic,copy) NSString *user_id;
@property(nonatomic,copy) NSString *token;
@end

@implementation GGChatTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mymessageArray=[NSMutableArray array];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.user_id=[defaults objectForKey:@"user_id"];
    self.token=[defaults objectForKey:@"token"];
    
    UINib *nib=[UINib nibWithNibName:@"GGChatTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"GGChatTableViewCell"];
    
    
    self.navigationItem.title=@"我的私信";
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSMutableDictionary *param=[NSMutableDictionary dictionary];
//    param[@"uid"]=self.user_id;
//    param[@"token"]=self.token;
//    
//    [manager GET:MY_MESSAGE_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSArray *messages=responseObject;
//
//        [self.mymessageArray removeAllObjects];
//        
//        for (NSDictionary *mes in messages) {
//            
//            Mymessage *message=[Mymessage objectWithKeyValues:mes];
//            [self.mymessageArray addObject:message];
//        }
//        [self.tableView reloadData];
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD showError:@"网络问题，加载失败～"];
//    }];


}

-(void)viewDidAppear:(BOOL)animated
{
    [self.mymessageArray removeAllObjects];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    
    [manager GET:MY_MESSAGE_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *messages=responseObject;
        
        for (NSDictionary *mes in messages) {
            
            Mymessage *message=[Mymessage objectWithKeyValues:mes];
            [self.mymessageArray addObject:message];
        }
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络问题，加载失败～"];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.mymessageArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGChatTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GGChatTableViewCell"];
    if (!cell) {
        cell = [[GGChatTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GGChatTableViewCell"];
    }
    if (!cell.notif) {
        cell.notif=[[RKNotificationHub alloc] initWithView:cell.chatImage];
        [cell.notif setCircleAtFrame:CGRectMake(35,0, 8, 8)];
        [cell.notif hideCount];
    }
    Mymessage *message=self.mymessageArray[indexPath.row];
    NSString *msg=[NSString stringWithFormat:@"最后私信:%@",message.msg];
    cell.lastContent.text=msg;
    
    int num_temp;
    
    if (self.user_id.intValue==message.touser.intValue) {
        num_temp=message.anon.intValue;
    }else{
        num_temp=(message.anon.intValue+message.randint.intValue)%100;
    }
    
//    RKNotificationHub *hub=[[RKNotificationHub alloc] initWithView:cell.lastContent];
//    
    cell.notif.count=message.unreadnum.intValue;
    
    [cell.chatImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d.png",COMMENT_PIC_URL,num_temp]] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGNewMessageTableViewController *frame=[[GGNewMessageTableViewController alloc] init];
    frame.fromuser_id=self.user_id;
    Mymessage *message=self.mymessageArray[indexPath.row];
    frame.touser_id=message.touser;
    GGNavigationController *nav=[[GGNavigationController alloc] initWithRootViewController:frame];
    [self presentViewController:nav animated:YES completion:nil];
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
