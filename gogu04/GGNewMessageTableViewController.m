//
//  GGNewMessageTableViewController.m
//  gogu04
//
//  Created by ren on 15/5/20.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGNewMessageTableViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "GoGuTool.h"
#import "Message.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "GGMessageTableViewCell.h"
#import "GGMessageFrame.h"
#import "MessageBottomBar.h"

@interface GGNewMessageTableViewController () <UITableViewDelegate,UITableViewDataSource,MessageBottomBarDelegate,UITextFieldDelegate>
@property (strong,nonatomic) NSString *uid;
@property (strong,nonatomic) NSString *token;
@property (strong,nonatomic) NSMutableArray *messages;
@property (weak,nonatomic) UITableView *messageTableView;
@property (weak,nonatomic) MessageBottomBar *messageBottomeBar;
@end

@implementation GGNewMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *uid=[defaults objectForKey:@"user_id"];
    NSString *token=[defaults objectForKey:@"token"];
    
    UITableView *messageTableView=[[UITableView alloc] init];
    CGFloat tableX=0;
    CGFloat tabelY=0;
    CGFloat tableW=self.view.frame.size.width;
    CGFloat tableH=self.view.frame.size.height-44;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    messageTableView.frame = CGRectMake(tableX, tabelY, tableW, tableH);
    
    messageTableView.delegate=self;
    messageTableView.dataSource=self;
    
    messageTableView.allowsSelection=NO;
    
    [self.view addSubview:messageTableView];
    self.messageTableView=messageTableView;
    
    self.messageTableView.backgroundColor=HWColor(225, 225, 225);
    
    self.messageTableView.separatorStyle=UITableViewCellSelectionStyleNone;
    
    self.view.window.backgroundColor=self.messageTableView.backgroundColor;
    
    MessageBottomBar *messageBottomeBar=[MessageBottomBar messageBar];
    CGFloat X=10;
    CGFloat Y=self.view.frame.size.height-44;
    CGFloat W=[UIScreen mainScreen].bounds.size.width-20;
    CGFloat H=44;
    
    messageBottomeBar.frame=CGRectMake(X, Y, W, H);
    messageBottomeBar.delegate=self;
    messageBottomeBar.messageContent.delegate=self;
    
    [self.view addSubview:messageBottomeBar];
    
    self.messageBottomeBar=messageBottomeBar;
    
    
    self.uid=uid;
    self.token=token;
    
    self.messages=[NSMutableArray array];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.uid;
    param[@"token"]=self.token;
    param[@"from_id"]=self.fromuser_id;
    param[@"to_id"]=self.touser_id;
    
    
    [manager GET:MESSAGES_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result=responseObject[@"result"];
        
        if ([result isEqualToString:@"ok"]) {
            
            
//            NSLog(@"%d",[[responseObject[@"msgArray"] componentsJoinedByString:(NSString *) isEqualToString:@"[]"]);
            
            NSArray *messagesDic=responseObject[@"msgArray"];
            
            for (NSDictionary *message in messagesDic) {
                Message *mess=[Message objectWithKeyValues:message];
                GGMessageFrame *frame=[[GGMessageFrame alloc] init];
                frame.message=mess;
                [self.messages addObject:frame];
            }
            
            [self.messageTableView reloadData];
            
            if (self.messages.count>0) {
                NSIndexPath *path=[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
                [self.messageTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
            }
            
            
            
//            if (![responseObject[@"msgArray"]isEqualToString:@"[]"]) {
//                NSArray *messagesDic=responseObject[@"msgArray"];
//                
//                
//            }
           
        }
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
//    // 4.监听键盘
//    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
//    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];


}

-(void)keyboardDidChange:(NSNotification *)noti
{
    CGRect frame=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat screenH=[[UIScreen mainScreen] bounds].size.height;
    CGFloat keyY=frame.origin.y;
    
    CGFloat keyDuration=[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:keyDuration animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, keyY-screenH);
    }];

}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

//- (void)keyboardWillHide:(NSNotification *)note
//{
//    // 1.键盘弹出需要的时间
//    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat keyboardH = keyboardF.size.height;
////    self.messageTableView.frame=CGRectMake(self.messageTableView.frame.origin.x, self.messageTableView.frame.origin.y, self.messageTableView.frame.size.width, self.messageTableView.frame.size.height+keyboardH+15);
//    
//    
//    // 2.动画
//    [UIView animateWithDuration:duration animations:^{
//        //        self.view.transform = CGAffineTransformIdentity;
//        self.messageBottomeBar.transform = CGAffineTransformIdentity;
//        //        self.commentTableView.transform = CGAffineTransformIdentity;
//        
//    }];
//    
//    
//}
//
///**
// *  键盘即将弹出
// */
//- (void)keyboardWillShow:(NSNotification *)note
//{
//    // 1.键盘弹出需要的时间
//    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat keyboardH = keyboardF.size.height;
////    self.messageTableView.frame=CGRectMake(self.messageTableView.frame.origin.x, self.messageTableView.frame.origin.y, self.messageTableView.frame.size.width, self.messageTableView.frame.size.height-keyboardH-15);
//    
//    
//    // 2.动画
//    [UIView animateWithDuration:duration animations:^{
//        // 取出键盘高度
//        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGFloat keyboardH = keyboardF.size.height;
//        //        self.view.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
//        self.messageBottomeBar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
//        //        self.commentTableView.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
//        
//    }];
//    
//}

-(void)clickSend:(MessageBottomBar *)bar
{
//    NSLog(@"aaaa,%@",bar.messageContent.text);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.uid;
    param[@"token"]=self.token;
    param[@"from_id"]=self.fromuser_id;
    param[@"to_id"]=self.touser_id;
    param[@"msg"]=bar.messageContent.text;
    
    
    [manager GET:NEW_MESSAGE_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result=responseObject[@"result"];
        
        if ([result isEqualToString:@"ok"]) {
            
            Message *mess=[Message objectWithKeyValues:responseObject[@"msg"]];
            
            GGMessageFrame *frame=[[GGMessageFrame alloc] init];
            frame.message=mess;
            [self.messages addObject:frame];
            
            [self.messageTableView reloadData];
            NSIndexPath *path=[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
            [self.messageTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            bar.messageContent.text=@"";
            [self.view endEditing:YES];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return [self.messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GGMessageTableViewCell *cell=[GGMessageTableViewCell messageCellWithTableView:tableView];
    
    
    cell.messageFrame=self.messages[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGMessageFrame *messageFrame=self.messages[indexPath.row];
    return messageFrame.cellH;
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
