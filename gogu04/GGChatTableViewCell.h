//
//  GGChatTableViewCell.h
//  gogu04
//
//  Created by ren on 15/5/23.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKNotificationHub;
@interface GGChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *chatImage;

@property (weak, nonatomic) IBOutlet UILabel *lastContent;

@property (strong,nonatomic) RKNotificationHub *notif;

@end
