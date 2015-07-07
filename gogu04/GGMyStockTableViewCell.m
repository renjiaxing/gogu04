//
//  GGMyStockTableViewCell.m
//  gogu04
//
//  Created by 任佳星 on 15/5/28.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGMyStockTableViewCell.h"
#import "Stock.h"

@implementation GGMyStockTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)followStock:(id)sender {
    
    UISwitch *uiSwitch=(UISwitch *)sender;
    BOOL isOn=[uiSwitch isOn];
    
    if (isOn) {
        NSLog(@"aaa");
        [self.delegate clickLike:self];
    }else{
        NSLog(@"off");
        [self.delegate clickNotLike:self];
    }
}
@end
