//
//  GGHomeTableViewController.m
//  gogu04
//
//  Created by ren on 15/3/31.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGHomeTableViewController.h"
#import "GGMicropostCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "Micropost.h"
#import "GGMicropostFrame.h"
#import "GoGuTool.h"
#import "GGMicropostDetailViewController.h"
#import "GGAddMicropostViewController.h"
#import "GGNavigationController.h"
#import "MBProgressHUD+MJ.h"
#import "GGNewMessageTableViewController.h"
#import "GGDropdownMenu.h"
#import "GGTitleMenuTableViewController.h"
#import "NSString+Extension.h"
#import "UIView+Extension.h"
#import "RKNotificationHub.h"

@interface GGHomeTableViewController () <GGDropdownMenuDelegate,GGtitleMenuTableViewDelegate>
@property(strong,nonatomic) NSMutableArray *micropostsFramesArray;
@property(strong,nonatomic) NSNumber *maxId;
@property(strong,nonatomic) NSNumber *minId;
@property(strong,nonatomic) NSString *user_id;
@property(strong,nonatomic) NSString *token;
@property(strong,nonatomic) NSString *my_stocks;
@property(strong,nonatomic) GGDropdownMenu *menu;
@end

@implementation GGHomeTableViewController

- (NSArray *)micropostFramesWithMicroposts:(NSArray *)microposts
{
    NSMutableArray *frames = [NSMutableArray array];
    for (NSDictionary *micropost in microposts) {
        GGMicropostFrame *f = [[GGMicropostFrame alloc] init];
        f.micropost = [Micropost objectWithKeyValues:micropost];
        [frames addObject:f];
    }
    return frames;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.user_id=[defaults objectForKey:@"user_id"];
    self.token=[defaults objectForKey:@"token"];
    NSLog(@"user_id %@ , token %@",self.user_id,self.token);
    
    self.micropostsFramesArray=[NSMutableArray array];
    
    if (self.my_id) {
        self.navigationItem.title=@"我的信息";
    }else if(self.my_reply_id){
        self.navigationItem.title=@"我的回复";
    }else if(self.stock_id){
        self.navigationItem.title=@"";
    }else{
        UIButton *titleButton=[[UIButton alloc] init];
        
        titleButton.frame=CGRectMake(0, 0, 150, 30);
        
        titleButton.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
        //    titleButton.imageEdgeInsets=UIEdgeInsetsMake(0, 70, 0, 0);
        
        
        [titleButton setTitle:@"全部信息" forState:UIControlStateNormal];
        [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.titleView=titleButton;
    }
    
    
    
    UIBarButtonItem *rightbutton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMicropost)];
    
    self.navigationItem.rightBarButtonItem=rightbutton;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;

    if (self.stock_id) {
        param[@"stock_id"]=self.stock_id;
    }
    
    if (self.my_id) {
        param[@"my_id"]=self.user_id;
    }
    
    if (self.my_reply_id) {
        param[@"my_reply_id"]=self.user_id;
    }
    
    if (self.my_stocks) {
        param[@"my_stocks"]=self.my_stocks;
    }
    
    [manager GET:MICROPOSTS_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *micropostsDict=responseObject[@"microposts"];
        
        NSArray *newFrams=[self micropostFramesWithMicroposts:micropostsDict];
        
        [self.micropostsFramesArray removeAllObjects];
        
        [self.micropostsFramesArray addObjectsFromArray:newFrams];
        
//        for (NSDictionary *mico in micropostsDict) {
//            Micropost *micropost=[Micropost objectWithKeyValues:mico];
//            NSLog(@"micropost:%@",micropost.content);
//            [self.micropostsArray addObject:micropost];
//        }
    
        UITabBarItem *item=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1];
        
        int unRead=[responseObject[@"unreadnum"] intValue]+[responseObject[@"unreadmicro"] intValue]+[responseObject[@"unreplymicro"] intValue];
        if (unRead==0) {
            item.badgeValue=nil;
        }else{
            item.badgeValue=[NSString stringWithFormat:@"%d",unRead];
        }
        if([self.micropostsFramesArray count]!=0){
            self.maxId=((Micropost *)(((GGMicropostFrame *)self.micropostsFramesArray[0]).micropost)).id;
            self.minId=((Micropost *)(((GGMicropostFrame *)self.micropostsFramesArray[[self.micropostsFramesArray count]-1]).micropost)).id;
        }

        
        [self.tableView reloadData];
        
        NSLog(@"max: %@,min: %@", self.maxId,self.minId);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [self setupRefresh];

}

-(void)dropdownMenuDidDismiss:(GGDropdownMenu *)menu
{
    UIButton *titleButton=(UIButton *)self.navigationItem.titleView;
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
}

-(void)titleClick:(UIButton *)titleButton
{
    GGDropdownMenu *menu=[GGDropdownMenu menu];
    
    menu.delegate=self;
    
    GGTitleMenuTableViewController *vc=[[GGTitleMenuTableViewController alloc] init];
    
    vc.delegate1=self;
    
    vc.view.height=44*2;
    vc.view.width=150;
    
    menu.contentController=vc;
    
    self.menu=menu;
    
    [menu showFrom:titleButton];
    
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
}

-(void)clickItem:(NSString *)item
{
    UIButton *titleButton=(UIButton *)self.navigationItem.titleView;
    [self.menu dismiss];
    [titleButton setTitle:item forState:UIControlStateNormal];
    if ([item isEqualToString:@"全部信息"]) {
        self.my_stocks=nil;
    }else{
        self.my_stocks=self.user_id;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    
    if (self.stock_id) {
        param[@"stock_id"]=self.stock_id;
    }
    
    if (self.my_id) {
        param[@"my_id"]=self.user_id;
    }
    
    if (self.my_reply_id) {
        param[@"my_reply_id"]=self.user_id;
    }
    
    if (self.my_stocks) {
        param[@"my_stocks"]=self.my_stocks;
    }
    
    [manager GET:MICROPOSTS_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *micropostsDict=responseObject[@"microposts"];
        
        NSArray *newFrams=[self micropostFramesWithMicroposts:micropostsDict];
        
        [self.micropostsFramesArray removeAllObjects];
        
        [self.micropostsFramesArray addObjectsFromArray:newFrams];
        
        //        for (NSDictionary *mico in micropostsDict) {
        //            Micropost *micropost=[Micropost objectWithKeyValues:mico];
        //            NSLog(@"micropost:%@",micropost.content);
        //            [self.micropostsArray addObject:micropost];
        //        }
        if([self.micropostsFramesArray count]!=0){
            self.maxId=((Micropost *)(((GGMicropostFrame *)self.micropostsFramesArray[0]).micropost)).id;
            self.minId=((Micropost *)(((GGMicropostFrame *)self.micropostsFramesArray[[self.micropostsFramesArray count]-1]).micropost)).id;
        }
        
        
        [self.tableView reloadData];
        
        NSLog(@"max: %@,min: %@", self.maxId,self.minId);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.micropostsFramesArray removeAllObjects];
    
    //    self.tableView.userInteractionEnabled=NO;
    
    UIBarButtonItem *rightbutton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMicropost)];
    
    self.navigationItem.rightBarButtonItem=rightbutton;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    
    if (self.stock_id) {
        param[@"stock_id"]=self.stock_id;
    }
    
    if (self.my_id) {
        param[@"my_id"]=self.user_id;
    }
    
    if (self.my_reply_id) {
        param[@"my_reply_id"]=self.user_id;
    }
    
    if (self.my_stocks) {
        param[@"my_stocks"]=self.my_stocks;
    }
    
    [manager GET:MICROPOSTS_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *micropostsDict=responseObject[@"microposts"];
        
        NSArray *newFrams=[self micropostFramesWithMicroposts:micropostsDict];
        
        [self.micropostsFramesArray removeAllObjects];
        
        [self.micropostsFramesArray addObjectsFromArray:newFrams];
        
        //        for (NSDictionary *mico in micropostsDict) {
        //            Micropost *micropost=[Micropost objectWithKeyValues:mico];
        //            NSLog(@"micropost:%@",micropost.content);
        //            [self.micropostsArray addObject:micropost];
        //        }
        
        UITabBarItem *item=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1];
        
        int unRead=[responseObject[@"unreadnum"] intValue]+[responseObject[@"unreadmicro"] intValue]+[responseObject[@"unreplymicro"] intValue];
        if (unRead==0) {
            item.badgeValue=nil;
        }else{
            item.badgeValue=[NSString stringWithFormat:@"%d",unRead];
        }
        
        if([self.micropostsFramesArray count]!=0){
            self.maxId=((Micropost *)(((GGMicropostFrame *)self.micropostsFramesArray[0]).micropost)).id;
            self.minId=((Micropost *)(((GGMicropostFrame *)self.micropostsFramesArray[[self.micropostsFramesArray count]-1]).micropost)).id;
        }
        
        
        [self.tableView reloadData];
        
        NSLog(@"max: %@,min: %@", self.maxId,self.minId);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
#warning 自动刷新(一进入程序就下拉刷新)
    //    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    //    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    //    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在努力加载中～";
    
    //    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    //    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在努力加载中～";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    if(self.maxId){
        param[@"up"]=self.maxId;
    }else{
        param[@"up"]=@"0";
    }
    if(self.stock_id){
        param[@"stock_id"]=self.stock_id;
    }
    
    if (self.my_id) {
        param[@"stock_id"]=self.user_id;
    }
    
    if (self.my_reply_id) {
        param[@"my_reply_id"]=self.user_id;
    }
    
    if (self.my_stocks) {
        param[@"my_stocks"]=self.my_stocks;
    }
    
    [manager GET:UP_MICROPOSTS_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *micropostsDict=responseObject[@"microposts"];
        
        for (NSDictionary *mico in micropostsDict) {
            Micropost *micropost=[Micropost objectWithKeyValues:mico];
            GGMicropostFrame *f = [[GGMicropostFrame alloc] init];
            f.micropost=micropost;
            [self.micropostsFramesArray insertObject:f atIndex:0];
        }
        
        if([self.micropostsFramesArray count]!=0){
            self.maxId=((Micropost *)(((GGMicropostFrame *)self.micropostsFramesArray[0]).micropost)).id;
        }
        
        UITabBarItem *item=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1];
        
        int unRead=[responseObject[@"unreadnum"] intValue]+[responseObject[@"unreadmicro"] intValue]+[responseObject[@"unreplymicro"] intValue];
        if (unRead==0) {
            item.badgeValue=nil;
        }else{
            item.badgeValue=[NSString stringWithFormat:@"%d",unRead];
        }
        
        [self.tableView reloadData];
        
        NSLog(@"max: %@,min: %@", self.maxId,self.minId);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [self.tableView headerEndRefreshing];
}

- (void)footerRereshing
{
    // 1.添加假数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    if(self.minId){
        param[@"down"]=self.minId;
    }else{
        param[@"down"]=@"0";
    }
    
    if(self.stock_id){
        param[@"stock_id"]=self.stock_id;
    }
    
    if (self.my_id) {
        param[@"stock_id"]=self.user_id;
    }
    
    if (self.my_reply_id) {
        param[@"my_reply_id"]=self.user_id;
    }
    
    if (self.my_stocks) {
        param[@"my_stocks"]=self.my_stocks;
    }
    
    [manager GET:DOWN_MICROPOSTS_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *micropostsDict=responseObject[@"microposts"];
        for (NSDictionary *mico in micropostsDict) {
            Micropost *micropost=[Micropost objectWithKeyValues:mico];
            GGMicropostFrame *f = [[GGMicropostFrame alloc] init];
            f.micropost=micropost;
            [self.micropostsFramesArray addObject:f];
        }
        
        if([self.micropostsFramesArray count]!=0){
            self.minId=((Micropost *)(((GGMicropostFrame *)self.micropostsFramesArray[[self.micropostsFramesArray count]-1]).micropost)).id;
        }
        
        UITabBarItem *item=(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:1];
        
        int unRead=[responseObject[@"unreadnum"] intValue]+[responseObject[@"unreadmicro"] intValue]+[responseObject[@"unreplymicro"] intValue];
        if (unRead==0) {
            item.badgeValue=nil;
        }else{
            item.badgeValue=[NSString stringWithFormat:@"%d",unRead];
        }
        
        [self.tableView reloadData];
        
        NSLog(@"max: %@,min: %@", self.maxId,self.minId);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [self.tableView footerEndRefreshing];
    
}

-(void)addMicropost{
    GGAddMicropostViewController *frame=[[GGAddMicropostViewController alloc] init];
    GGNavigationController *nav=[[GGNavigationController alloc] initWithRootViewController:frame];
    [self presentViewController:nav animated:YES completion:nil];
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
    return [self.micropostsFramesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGMicropostCell *cell = [GGMicropostCell cellWithTableView:tableView];
    
    
    
    cell.micropostFrame=self.micropostsFramesArray[indexPath.row];
    
    [cell.stockButton addTarget:self action:@selector(stockClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likeButton addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.msgButton addTarget:self action:@selector(msgClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.delButton addTarget:self action:@selector(delClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.changeButton addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.chatButton addTarget:self action:@selector(chatClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:cell.stockButton];
    [cell addSubview:cell.likeButton];
    [cell addSubview:cell.msgButton];
    [cell addSubview:cell.delButton];
    [cell addSubview:cell.changeButton];
    [cell addSubview:cell.chatButton];
    
    return cell;
}

-(void) stockClick:(id)sender
{
    GGMicropostCell *cell = (GGMicropostCell *)[sender superview];
//    NSIndexPath *path=[self.tableView indexPathForCell:cell];
    GGHomeTableViewController *stockVC=[[GGHomeTableViewController alloc] init];
    stockVC.stock_id=cell.micropostFrame.micropost.stock_id;
    [self.navigationController pushViewController:stockVC animated:YES];
    
//    NSLog(@"%@",cell.micropostFrame.micropost.stock_id);
}

-(void) likeClick:(id)sender
{
    GGMicropostCell *cell = (GGMicropostCell *)[sender superview];
    Micropost *micropost=cell.micropostFrame.micropost;
    if ([micropost.good isEqualToString:@"true"]) {
        [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"ic_card_like_grey"] forState:UIControlStateNormal];
        micropost.good=@"false";
        int tempNum=micropost.good_number.intValue;
        tempNum-=1;
        micropost.good_number=[NSNumber numberWithInt:tempNum];
        cell.likenumLabel.text=[NSString stringWithFormat:@"%@",micropost.good_number];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *param=[NSMutableDictionary dictionary];
        param[@"uid"]=self.user_id;
        param[@"token"]=self.token;
        param[@"mid"]=micropost.id;
        
        [manager GET:NOGOOD_MICROPOST_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *result=responseObject[@"result"];
            
            NSLog(@"%@",result);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }else{
        [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"ic_card_liked"] forState:UIControlStateNormal];
        micropost.good=@"true";
        int tempNum=micropost.good_number.intValue;
        tempNum+=1;
        micropost.good_number=[NSNumber numberWithInt:tempNum];
        cell.likenumLabel.text=[NSString stringWithFormat:@"%@",micropost.good_number];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *param=[NSMutableDictionary dictionary];
        param[@"uid"]=self.user_id;
        param[@"token"]=self.token;
        param[@"mid"]=micropost.id;
        
        [manager GET:GOOD_MICROPOST_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *result=responseObject[@"result"];
            
            NSLog(@"%@",result);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

-(void) msgClick:(id)sender
{
    GGMicropostCell *cell = (GGMicropostCell *)[sender superview];
    GGMicropostDetailViewController *detailVC=[[GGMicropostDetailViewController alloc] init];
    detailVC.micropost=cell.micropostFrame.micropost;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void) delClick:(id)sender
{
    GGMicropostCell *cell = (GGMicropostCell *)[sender superview];
    Micropost *micropost=cell.micropostFrame.micropost;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    param[@"mid"]=micropost.id;
    
    [manager GET:DEL_MICROPOST_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result=responseObject[@"result"];
        
        if ([result isEqualToString:@"ok"]) {
            [self.micropostsFramesArray removeObject:cell.micropostFrame];
            [MBProgressHUD showSuccess:@"删除成功～"];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:@"删除失败～"];
        }
        
//        NSLog(@"%@",result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
        [MBProgressHUD showError:@"网络故障～"];
    }];
}

-(void) changeClick:(id)sender
{
    GGMicropostCell *cell = (GGMicropostCell *)[sender superview];
    GGAddMicropostViewController *changeVC=[[GGAddMicropostViewController alloc] init];
    changeVC.micropost=cell.micropostFrame.micropost;
    GGNavigationController *nav=[[GGNavigationController alloc] initWithRootViewController:changeVC];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)chatClick:(id)sender
{
    GGNewMessageTableViewController *frame=[[GGNewMessageTableViewController alloc] init];
    frame.fromuser_id=self.user_id;
    GGMicropostCell *cell=(GGMicropostCell *)[sender superview];
    frame.touser_id=cell.micropostFrame.micropost.user_id.stringValue;
    GGNavigationController *nav=[[GGNavigationController alloc] initWithRootViewController:frame];
    [self presentViewController:nav animated:YES completion:nil];
}
//
//-(void)likeClick
//{
//    NSLog(@"bbb");
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGMicropostFrame *frame = self.micropostsFramesArray[indexPath.row];
    return frame.cellHeight;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGMicropostDetailViewController *frame=[[GGMicropostDetailViewController alloc] init];
//    frame.micropost_id=((GGMicropostFrame *)self.micropostsFramesArray[indexPath.row]).micropost.id;
    frame.micropost=((GGMicropostFrame *)self.micropostsFramesArray[indexPath.row]).micropost;
    [self.navigationController pushViewController:frame animated:YES];
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
