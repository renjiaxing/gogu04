//
//  GGMessageTableViewCell.h
//  gogu04
//
//  Created by ren on 15/5/20.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGMessageFrame;
@interface GGMessageTableViewCell : UITableViewCell

+ (instancetype)messageCellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) GGMessageFrame *messageFrame;
@property(nonatomic,strong) NSString *user_id;
@property (assign,nonatomic) int randint;

@end
