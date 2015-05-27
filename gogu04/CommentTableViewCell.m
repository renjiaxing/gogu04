//
//  CommentTableViewCell.m
//  gogu03
//
//  Created by ren on 15/3/10.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GoGuTool.h"
#import "AFNetworking.h"


@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)delComment:(id)sender {
    
    [self.delegate clickDel:self];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSMutableDictionary *param=[NSMutableDictionary dictionary];
//    param[@"uid"]=self.user_id;
//    param[@"token"]=self.token;
//    param[@"cid"]=self.comment.id;
//    
//    [manager POST:DEL_COMMENT_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSString *result=responseObject[@"result"];
//        
//        if ([result isEqualToString:@"ok"]) {
//            [self.commentsAarry removeObject:self.comment];
//            [self.tableview reloadData];
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];

}

-(void)setComment:(Comment *)comment
{
    _comment=comment;
    int num_temp=(self.randint+comment.anonid.intValue)%100;
    [self.commentImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d.png",COMMENT_PIC_URL,num_temp]] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    self.commentContent.text=comment.msg;
    self.commentTime.text=comment.created_at;
    
    if (comment.user_id.intValue==self.user_id.intValue) {
        self.commentDelButton.enabled=true;
        [self.commentDelButton setTitle:@"删除" forState:UIControlStateNormal];

    }else{
        self.commentDelButton.enabled=false;
        [self.commentDelButton setTitle:@"" forState:UIControlStateNormal];
    }
}

@end
