//
//  CommentTableViewCell.h
//  gogu03
//
//  Created by ren on 15/3/10.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@class CommentTableViewCell;
@protocol CommentTableCellDelegate <NSObject>

-(void)clickDel:(CommentTableViewCell *)cell;

@end

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;
@property (weak, nonatomic) IBOutlet UIButton *commentDelButton;

@property (strong,nonatomic) Comment *comment;
@property (copy,nonatomic) NSString *user_id;
@property (copy,nonatomic) NSString *token;

@property (assign,nonatomic) int randint;

@property (nonatomic,weak) id<CommentTableCellDelegate> delegate;

//@property (strong,nonatomic) NSMutableArray *commentsAarry;
//@property (strong,nonatomic) UITableView *tableview;
//
//@property (nonatomic, assign) CGRect frame;

@end
