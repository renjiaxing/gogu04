//
//  GGTitleMenuTableViewController.h
//  gogu04
//
//  Created by ren on 15/5/24.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GGtitleMenuTableViewDelegate <NSObject>

-(void)clickItem:(NSString *)item;

@end
@interface GGTitleMenuTableViewController : UITableViewController
//@property(nonatomic,strong) UIButton *titleButton;
//@property(nonatomic,strong) NSMutableArray *messageArray;
@property(nonatomic,weak) id<GGtitleMenuTableViewDelegate> delegate1;
@end
