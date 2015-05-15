//
//  GGAddMicropostViewController.m
//  gogu04
//
//  Created by ren on 15/4/14.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGAddMicropostViewController.h"
#import "MLPAutoCompleteTextField.h"
#import "NSString+Levenshtein.h"
#import "MLPAutoCompletionObject.h"
#import "MLPAutoCompleteTextFieldDelegate.h"
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "GoGuTool.h"
#import "AFNetworking.h"
#import "Stock.h"
#import "MJExtension.h"
#import "GGPlaceholderTextView.h"
#import "MBProgressHUD+MJ.h"
#import "Micropost.h"
#import "UIImageView+WebCache.h"

@interface GGAddMicropostViewController ()<UITextFieldDelegate, MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate,
    UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet GGPlaceholderTextView *content;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *stock;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property(strong,nonatomic) NSMutableArray *stockArray;
@property (weak, nonatomic) UIImage *photo;
@property (weak,nonatomic) NSString * uid;
@property (weak,nonatomic) NSString * token;
@end

@implementation GGAddMicropostViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *uid=[defaults objectForKey:@"user_id"];
    NSString *token=[defaults objectForKey:@"token"];
    
    self.stock.tag=2;
    self.content.tag=1;
    
    self.uid=uid;
    self.token=token;
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];

    self.navigationItem.title=@"发送信息";
    self.stock.autoCompleteDataSource=self;
    self.stock.autoCompleteDelegate=self;
    self.stock.delegate=self;
//    self.stock.autoCompleteTableAppearsAsKeyboardAccessory=true;
    self.content.placeholder=@"请输入信息";
    self.content.placeholderColor=[UIColor whiteColor];
    self.content.textColor=[UIColor whiteColor];
    self.stockArray=[NSMutableArray array];
    self.navigationItem.rightBarButtonItem.enabled=NO;
    
    if (self.micropost) {
        self.content.text=self.micropost.content;
        self.stock.text=self.micropost.stock_full_name;
        if (self.micropost.image) {
            [self.photoBtn.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERV_URL,self.micropost.image]] placeholderImage:[UIImage imageNamed:@"pic_add"]];
        }
    }
    
    [self.photoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    
//    [center addObserver:self selector:@selector(keyBoardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [center addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self.content];


    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{

    [UIView animateWithDuration:0.3f animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, -212);
    }];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
}


//-(void) keyBoardDidChangeFrame:(NSNotification *)noti
//{
//    CGRect keyboardFrame=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    CGFloat screenH=[[UIScreen mainScreen] bounds].size.height;
//    
//    CGFloat keyY=keyboardFrame.origin.y;
//    
//    CGFloat keyDuration=[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    
//    [UIView animateWithDuration:keyDuration animations:^{
//        self.view.transform=CGAffineTransformMakeTranslation(0, keyY-screenH+40);
//    }];
//    
//
//}

-(void)addPhoto
{
    [self openAlbum];
}

- (void)openAlbum
{
    // 如果想自己写一个图片选择控制器，得利用AssetsLibrary.framework，利用这个框架可以获得手机上的所有相册图片
    // UIImagePickerControllerSourceTypePhotoLibrary > UIImagePickerControllerSourceTypeSavedPhotosAlbum
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.photo=image;
    
    [self.photoBtn setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = self.content.hasText;
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)send{
    
    if ([self.stock.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"股票代码没有填写～"];
    }else if([self.content.text isEqual:@""]){
        [MBProgressHUD showError:@"内容不能为空～"];
    }else if (self.photo) {
        [self sendWithImage];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self sendWithoutImage];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    // dismiss


}

-(void) sendWithoutImage
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.uid;
    param[@"token"]= self.token;
    param[@"micropost[user_id]"]=self.uid;
    param[@"micropost[content]"]=self.content.text;
    param[@"micropost[stock_id]"]=[self.stock.text componentsSeparatedByString:@","][0];
    
    if (self.micropost) {
        param[@"mid"]=self.micropost.id;
        [manager POST:CHANGE_MICROPOST_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"%@",responseObject);
            [MBProgressHUD showSuccess:@"发送成功"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [MBProgressHUD showError:@"发送失败"];
        }];
    }else{
        
        [manager POST:NEW_MICROPOST_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"%@",responseObject);
            [MBProgressHUD showSuccess:@"发送成功"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [MBProgressHUD showError:@"发送失败"];
        }];
    }
}

-(void)sendWithImage
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=self.uid;
    param[@"token"]= self.token;
    param[@"micropost[user_id]"]=self.uid;
    param[@"micropost[content]"]=self.content.text;
    param[@"micropost[stock_id]"]=[self.stock.text componentsSeparatedByString:@","][0];
    
    
//    [manager POST:NEW_MICROPOST_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [MBProgressHUD showSuccess:@"发送成功"];
//        NSLog(@"%@",responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        [MBProgressHUD showError:@"发送失败"];
//    }];
    
    if(self.micropost){
        param[@"mid"]=self.micropost.id;
        [manager POST:CHANGE_MICROPOST_URL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            // 拼接文件数据
            UIImage *image = self.photo;
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            [formData appendPartWithFileData:data name:@"micropost[image]" fileName:@"pic.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            [MBProgressHUD showSuccess:@"发送成功"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"发送失败"];
        }];
    }else{
        
        [manager POST:NEW_MICROPOST_URL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            // 拼接文件数据
            UIImage *image = self.photo;
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            [formData appendPartWithFileData:data name:@"micropost[image]" fileName:@"pic.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            [MBProgressHUD showSuccess:@"发送成功"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"发送失败"];
        }];
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        
        
        //        NSArray *completions=@[@"aaa",@"abc"];
        //        NSLog(@"%@",string);
        
        [self.stockArray removeAllObjects];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *param=[NSMutableDictionary dictionary];
        param[@"code"]=string;
        param[@"maxRows"]= @"10";
        
        
        [manager GET:CHECK_STOCK_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *stockDict=responseObject;
            for (NSDictionary *sto in stockDict) {
                Stock *stock=[Stock objectWithKeyValues:sto];
                
                NSString *stockString=[NSString stringWithFormat:@"%@,%@,%@",stock.code,stock.name,stock.shortname];
                NSLog(@"stock:%@",stockString);
                [self.stockArray addObject:stockString];
            }
            handler(self.stockArray);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        NSLog(@"%@",self.stockArray);
        
        //        handler(self.stockArray);
    });
}

- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




@end
