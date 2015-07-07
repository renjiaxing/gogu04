//
//  GGMyStockTableViewController.m
//  gogu04
//
//  Created by 任佳星 on 15/5/28.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGMyStockTableViewController.h"
#import "Stock.h"
#import "GGMyStockTableViewCell.h"
#import "AFNetworking.h"
#import "GoGuTool.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "GGAddMyStockTableViewController.h"
#import "GGNavigationController.h"

@interface GGMyStockTableViewController () <GGMyStockTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *mystockArray;
@property(nonatomic,copy) NSString *user_id;
@property(nonatomic,copy) NSString *token;
@end

@implementation GGMyStockTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mystockArray=[NSMutableArray array];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.user_id=[defaults objectForKey:@"user_id"];
    self.token=[defaults objectForKey:@"token"];
    
    UIBarButtonItem *rightbutton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addStockFollow)];
    
    self.navigationItem.rightBarButtonItem=rightbutton;
    
    UINib *nib=[UINib nibWithNibName:@"GGMyStockTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"GGMyStockTableViewCell"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.mystockArray removeAllObjects];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    
    [manager GET:MY_STOCK_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *mystocks=responseObject[@"stocks"];
        
        for (NSDictionary *stock in mystocks) {
            
            Stock *mystock=[Stock objectWithKeyValues:stock];
            [self.mystockArray addObject:mystock];
        }
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络问题，加载失败～"];
    }];
}

-(void)addStockFollow
{
    GGAddMyStockTableViewController *vc=[[GGAddMyStockTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    return [self.mystockArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGMyStockTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GGMyStockTableViewCell" forIndexPath:indexPath];
    Stock *stock=self.mystockArray[indexPath.row];
    
    cell.stockName.text=stock.name;
    cell.stock=stock;
    
    cell.delegate=self;
    
    return cell;
}


-(void)clickLike:(GGMyStockTableViewCell *)cell
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    param[@"sid"]=cell.stock.id.stringValue;
    
    [manager POST:ADDSTOCK_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result=responseObject[@"result"];
        
        if (![result isEqualToString:@"ok"]) {
            [MBProgressHUD showError:@"关注失败，请稍后再试～"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络问题，加载失败～"];
    }];
}

-(void)clickNotLike:(GGMyStockTableViewCell *)cell
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    param[@"sid"]=cell.stock.id.stringValue;
    
    [manager POST:DELSTOCK_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result=responseObject[@"result"];
        
        if (![result isEqualToString:@"ok"]) {
            [MBProgressHUD showError:@"关注取消失败，请稍后再试～"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络问题，加载失败～"];
    }];
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
