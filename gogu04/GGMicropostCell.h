//
//  GGMicropostCell.h
//  gogu04
//
//  Created by ren on 15/4/1.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGMicropostFrame,RKNotificationHub;
@interface GGMicropostCell : UITableViewCell
@property(nonatomic,weak) UIView *micropostView;
@property(nonatomic,weak) UILabel *contentLabel;
@property(nonatomic,weak) UIImageView *picView;
@property(nonatomic,weak) UILabel *timeLabel;
@property(nonatomic,weak) UIButton *stockButton;
@property(nonatomic,weak) UIButton *likeButton;
@property(nonatomic,weak) UILabel *likenumLabel;
@property(nonatomic,weak) UIButton *msgButton;
@property(nonatomic,weak) UILabel *msgnumLabel;
@property(nonatomic,weak) UIButton *chatButton;
@property(nonatomic,weak) UIButton *delButton;
@property(nonatomic,weak) UIButton *changeButton;
@property(nonatomic,strong) RKNotificationHub *notif;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) GGMicropostFrame *micropostFrame;
@end
