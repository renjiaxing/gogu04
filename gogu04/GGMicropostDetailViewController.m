//
//  GGMicropostDetailViewController.m
//  gogu04
//
//  Created by ren on 15/4/14.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGMicropostDetailViewController.h"
#import "MJPhoto.h"
#import "DetailBottomBar.h"
#import "GoGuTool.h"
#import "MJPhotoBrowser.h"
#import "DetailTopView.h"
#import "AFNetworking.h"
#import "DetailMicropost.h"
#import "MJExtension.h"
#import "Comment.h"
#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"

@interface GGMicropostDetailViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (copy,nonatomic) NSString *user_id;
@property (copy,nonatomic) NSString *token;
@property (strong,nonatomic) NSMutableArray *commentArray;
@property (weak,nonatomic) DetailBottomBar *detailBottomBar;
@property (weak,nonatomic) UITableView *commentTableView;
@property (weak,nonatomic) UIImageView *imagev;
@end

@implementation GGMicropostDetailViewController

- (void)tapImage1:(UITapGestureRecognizer *)tap
{
    int count = 1;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [NSString stringWithFormat:@"%@%@",SERV_URL,self.micropost.image];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = self.imagev; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UITableView *commentTableView=[[UITableView alloc] init];
    CGFloat tableX=0;
    CGFloat tabelY=0;
    CGFloat tableW=self.view.frame.size.width;
    CGFloat tableH=self.view.frame.size.height-44;
    NSLog(@"%f",self.view.frame.size.height-44);
    
    commentTableView.scrollEnabled=YES;
    commentTableView.showsVerticalScrollIndicator=YES;
    commentTableView.separatorStyle=UITableViewCellAccessoryNone;
    commentTableView.frame = CGRectMake(tableX, tabelY, tableW, tableH);
    
    [self.view addSubview:commentTableView];
    commentTableView.delegate=self;
    commentTableView.dataSource=self;
    
    self.commentTableView=commentTableView;
    
    UINib *nib=[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil];
    [self.commentTableView registerNib:nib forCellReuseIdentifier:@"CommentTableViewCell"];
    
    DetailTopView *detailTopView=[[DetailTopView alloc] init];
    detailTopView.micropost=self.micropost;
//    [detailTopView.stockButton addTarget:self action:@selector(clickStockButton) forControlEvents:UIControlEventTouchDown];
    
    
    self.commentTableView.tableHeaderView=detailTopView;
    
    
    //    UITextField *textField=[[UITextField alloc] init];
    //    textField.text=@"hjkhkjhjk";
    //    textField.textColor=[UIColor blackColor];
    //    CGFloat X=10;
    //    CGFloat Y=self.view.frame.size.height-100;
    //    CGFloat W=[UIScreen mainScreen].bounds.size.width-20;
    //    CGFloat H=44;
    //    textField.frame=CGRectMake(X, Y, W, H);
    //        NSLog(@"text:%f,%f,%f,%f",X,Y,W,H);
    //    [self.view addSubview:textField];
    //    self.bottomTF=textField;
    
    //    DetailBottomBar *detailBottomBar=[[DetailBottomBar alloc] init];
    DetailBottomBar *detailBottomBar=[DetailBottomBar toolbar];
    CGFloat X=10;
    CGFloat Y=self.view.frame.size.height-44;
    CGFloat W=[UIScreen mainScreen].bounds.size.width-20;
    CGFloat H=44;
    //    detailBottomBar.backgroundColor=[UIColor redColor];
    detailBottomBar.frame=CGRectMake(X, Y, W, H);
    detailBottomBar.micropost=self.micropost;
    [self.view addSubview:detailBottomBar];
    self.detailBottomBar=detailBottomBar;
    detailBottomBar.tableView=commentTableView;
    
    self.detailBottomBar.textInput.delegate=self;
    
    // 4.监听键盘
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.user_id=[defaults objectForKey:@"user_id"];
    self.token=[defaults objectForKey:@"token"];
    NSLog(@"user_id %@ , token %@",self.user_id,self.token);
    
    self.commentArray=[NSMutableArray array];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.user_id;
    param[@"token"]=self.token;
    param[@"mid"]=self.micropost.id;
    
    [manager GET:DETAIL_MICROPOST_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        DetailMicropost *micropost=[DetailMicropost objectWithKeyValues:responseObject];
        NSLog(@"%@",micropost.content);
        NSArray *commentsDict=responseObject[@"comments"];
        for (NSDictionary *com in commentsDict) {
            
            Comment *comment=[Comment objectWithKeyValues:com];
            NSLog(@"comments:%@",comment.msg);
            [self.commentArray addObject:comment];
        }
        detailBottomBar.commentArray=self.commentArray;
        [self.commentTableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络问题，加载失败～"];
    }];
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

//-(void)clickStockButton
//{
//    InterestTableViewController *newVc = [[InterestTableViewController alloc] init];
//    newVc.stock_id = self.micropost.stock_id;
//    newVc.stock_name = self.micropost.stock_name;
//    
//    [self.navigationController pushViewController:newVc animated:YES];
//}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}
//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardF.size.height;
    self.commentTableView.frame=CGRectMake(self.commentTableView.frame.origin.x, self.commentTableView.frame.origin.y, self.commentTableView.frame.size.width, self.commentTableView.frame.size.height+keyboardH+15);
 
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
//        self.view.transform = CGAffineTransformIdentity;
        self.detailBottomBar.transform = CGAffineTransformIdentity;
//        self.commentTableView.transform = CGAffineTransformIdentity;
        
    }];
    
    
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardF.size.height;
    self.commentTableView.frame=CGRectMake(self.commentTableView.frame.origin.x, self.commentTableView.frame.origin.y, self.commentTableView.frame.size.width, self.commentTableView.frame.size.height-keyboardH-15);

    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
//        self.view.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
        self.detailBottomBar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
//        self.commentTableView.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
        
    }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.commentArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *identifier=@"cell";
    //    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    //    if (cell==nil) {
    //        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    //    }
    CommentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
    Comment *comment=self.commentArray[indexPath.row];
//    if (![comment.user_id isEqualToString:self.user_id]) {
//        cell.commentDel.enabled=false;
//    }else{
//        [cell.commentDel addTarget:self action:@selector(delComment:) forControlEvents:UIControlEventTouchUpInside];
//        [cell addSubview:cell.commentDel];
//    }

    
    int num_temp=(self.micropost.randint.intValue+comment.anonid.intValue)%100;
    [cell.commentImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d.png",COMMENT_PIC_URL,num_temp]] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    cell.commentContent.text=comment.msg;
    cell.commentTime.text=comment.created_at;
    //    cell.textLabel.text=comment.msg;
    //    cell.detailTextLabel.text=comment.created_at;
    //    int num_temp=self.micropost.randint.intValue+comment.anonid.intValue;
    //    NSLog(@"%@%d.png",COMMENT_PIC_URL,num_temp);
    //
    //    [cell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d.png",COMMENT_PIC_URL,num_temp]] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    //    [cell setNeedsDisplay];
    return cell;
}

//-(void)delComment:(id)sender
//{
//    NSLog(@"aaaaa");
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end