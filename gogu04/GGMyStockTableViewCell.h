//
//  GGMyStockTableViewCell.h
//  gogu04
//
//  Created by 任佳星 on 15/5/28.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Stock,GGMyStockTableViewCell;

@protocol GGMyStockTableViewCellDelegate <NSObject>

-(void)clickLike:(GGMyStockTableViewCell *)cell;
-(void)clickNotLike:(GGMyStockTableViewCell *)cell;

@end

@interface GGMyStockTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stockName;
@property (weak, nonatomic) IBOutlet UISwitch *stockSwitch;

- (IBAction)followStock:(id)sender;

@property (strong,nonatomic) Stock *stock;
@property (weak,nonatomic) id<GGMyStockTableViewCellDelegate> delegate;

@end
