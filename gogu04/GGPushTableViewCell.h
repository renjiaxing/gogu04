//
//  GGPushTableViewCell.h
//  gogu04
//
//  Created by 任佳星 on 15/6/14.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGPushTableViewCell;

@protocol GGPushTableViewCellDelegate <NSObject>

-(void)clickPush:(GGPushTableViewCell *)cell;
-(void)clickNotPush:(GGPushTableViewCell *)cell;

@end

@interface GGPushTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pushLabel;
- (IBAction)pushSwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *pSwitch;

@property (weak,nonatomic) id<GGPushTableViewCellDelegate> delegate;
@end
