//
//  DetailBottomBar.h
//  gogu03
//
//  Created by ren on 15/3/6.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Micropost.h"

@interface DetailBottomBar : UIView
+(instancetype)toolbar;
@property (weak,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *commentArray;
@property (strong,nonatomic) Micropost *micropost;
@end
