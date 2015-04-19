//
//  GGSearchTableViewController.m
//  gogu04
//
//  Created by ren on 15/3/31.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGSearchTableViewController.h"
#import "AFNetworking.h"
#import "GoGuTool.h"
#import "Stock.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "GGHomeTableViewController.h"

@interface GGSearchTableViewController () <UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong) NSMutableArray *results;
@property(nonatomic,strong) NSMutableArray *stockids;
@property(nonatomic,strong) UISearchController *searchVC;
@end

@implementation GGSearchTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.results=[NSMutableArray array];
    self.stockids=[NSMutableArray array];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.searchVC=[[UISearchController alloc] initWithSearchResultsController:nil];
    // Uncomment the following line to preserve selection between presentations.
//    self.clearsSelectionOnViewWillAppear = NO;
    self.searchVC.dimsBackgroundDuringPresentation=NO;
    [_searchVC.searchBar sizeToFit];
    self.searchVC.searchResultsUpdater=self;
    
    self.searchVC.hidesNavigationBarDuringPresentation=NO;
    
    self.searchVC.searchBar.placeholder=@"搜索";
    
    [self.searchVC.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    
//    UIButton *btn=(UIButton *)[self.searchVC.searchBar valueForKey:@"cancelButton"];
    
//    self.searchVC.searchBar.showsCancelButton=false;
//    
//    for (UIView *view in self.searchVC.searchBar.subviews) {
//        for (id subview in view.subviews) {
//            if ([subview isKindOfClass:[UIButton class]]) {
//                [subview setEnabled:YES];
//                UIButton *cancelButton=(UIButton *)subview;
//                [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//                return;
//            }
//
//        }
//    }
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.tableView.tableHeaderView=self.searchVC.searchBar;
    self.navigationItem.titleView=self.searchVC.searchBar;
    
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self.results removeAllObjects];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"code"]=searchController.searchBar.text;
    param[@"maxRows"]= @"10";
    
    
    [manager GET:CHECK_STOCK_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *stockDict=responseObject;
        for (NSDictionary *sto in stockDict) {
            Stock *stock=[Stock objectWithKeyValues:sto];
            
            NSString *stockString=[NSString stringWithFormat:@"%@,%@,%@",stock.code,stock.name,stock.shortname];
            NSNumber *stock_id=stock.id;
            [self.results addObject:stockString];
            [self.stockids addObject:stock_id];
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误，请稍候再试～"];
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
    return [self.results count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    // Configure the cell...
    cell.textLabel.text=self.results[indexPath.row];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGHomeTableViewController *stockMicroposts=[[GGHomeTableViewController alloc] init];
    //    frame.micropost_id=((GGMicropostFrame *)self.micropostsFramesArray[indexPath.row]).micropost.id;
    stockMicroposts.stock_id=self.stockids[indexPath.row];
 
    [self.navigationController pushViewController:stockMicroposts animated:YES];
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
