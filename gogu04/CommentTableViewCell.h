//
//  CommentTableViewCell.h
//  gogu03
//
//  Created by ren on 15/3/10.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;

//@property (strong,nonatomic) Comment *comment;
//
//@property (nonatomic, assign) CGRect frame;

@end
