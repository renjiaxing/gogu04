//
//  DetailBottomBar.m
//  gogu03
//
//  Created by ren on 15/3/6.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "DetailBottomBar.h"
#import "Comment.h"
#import "AFNetworking.h"
#import "GoGuTool.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"

@interface DetailBottomBar()
@property (weak, nonatomic) IBOutlet UITextField *textInput;
@end

@implementation DetailBottomBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)send:(id)sender {
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *user_id=[defaults objectForKey:@"user_id"];
    NSString *token=[defaults objectForKey:@"token"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"uid"]=user_id;
    param[@"token"]=token;
    param[@"mid"]=self.micropost.id;
    param[@"msg"]=self.textInput.text;
    
    [manager POST:NEW_COMMENT_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.commentArray removeAllObjects];
        
        NSArray *commentsDict=responseObject[@"comments"];
        for (NSDictionary *com in commentsDict) {
            
            Comment *comment=[Comment objectWithKeyValues:com];
            NSLog(@"comments:%@",comment.msg);
            [self.commentArray addObject:comment];
            
        }

        self.textInput.text=@"";
        [self.tableView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络问题，评论失败～"];
    }];


}

- (IBAction)weixin:(id)sender {
    NSLog(@"bbb");
}


- (IBAction)friend:(id)sender {
    NSLog(@"ccc");
}


+(instancetype)toolbar
{
    return [[[NSBundle mainBundle] loadNibNamed:@"DetailBottomBar" owner:nil options:nil] lastObject];
}


//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder]) {
//        UIView *containerView = [[[UINib nibWithNibName:@"DetailBottom" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
//        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        containerView.frame = newFrame;
//        [self addSubview:containerView];
//    }
//    return self;
//}


@end
