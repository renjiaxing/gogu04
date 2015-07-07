//
//  GGAddMyStockTableViewController.m
//  gogu04
//
//  Created by 任佳星 on 15/5/28.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGAddMyStockTableViewController.h"
#import "AFNetworking.h"
#import "GoGuTool.h"
#import "Stock.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "GGHomeTableViewController.h"
#import "GGMyStockTableViewCell.h"

@interface GGAddMyStockTableViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextViewDelegate,GGMyStockTableViewCellDelegate>
@property(nonatomic,strong) NSMutableArray *results;
@property(nonatomic,strong) NSMutableArray *stockids;
@property(nonatomic,strong) NSMutableArray *stockArray;
@property(nonatomic,copy) NSString *user_id;
@property(nonatomic,copy) NSString *token;

@end

@implementation GGAddMyStockTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.results=[NSMutableArray array];
    self.stockids=[NSMutableArray array];
    self.stockArray=[NSMutableArray array];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.user_id=[defaults objectForKey:@"user_id"];
    self.token=[defaults objectForKey:@"token"];
    
    UINib *nib=[UINib nibWithNibName:@"GGMyStockTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"GGMyStockTableViewCell"];
    
    UISearchBar *searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 40)];
    searchBar.delegate=self;
    self.navigationItem.titleView=searchBar;
    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    [theSearchBar resignFirstResponder];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
{
    [searchBar resignFirstResponder];
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.results removeAllObjects];
    [self.stockids removeAllObjects];
    [self.stockArray removeAllObjects];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    param[@"code"]=searchText;
    param[@"maxRows"]= @"10";
    
    
    [manager GET:CHECK_ALL_STOCK_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *stockDict=responseObject;
        for (NSDictionary *sto in stockDict) {
            Stock *stock=[Stock objectWithKeyValues:sto];
            
            NSString *stockString=[NSString stringWithFormat:@"%@,%@,%@",stock.code,stock.name,stock.shortname];
            NSNumber *stock_id=stock.id;
            [self.results addObject:stockString];
            [self.stockids addObject:stock_id];
            [self.stockArray addObject:stock];
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误，请稍候再试～"];
    }];
    
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
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGMyStockTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GGMyStockTableViewCell" forIndexPath:indexPath];
    Stock *stock=self.stockArray[indexPath.row];
    
    cell.stockName.text=stock.name;
    cell.stock=stock;
    
    if ([stock.follow isEqualToString:@"true"]) {
        [cell.stockSwitch setOn:YES];
    }else{
        [cell.stockSwitch setOn:NO];
    }
    
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
