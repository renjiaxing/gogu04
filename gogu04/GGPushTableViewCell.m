//
//  GGPushTableViewCell.m
//  gogu04
//
//  Created by 任佳星 on 15/6/14.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGPushTableViewCell.h"

@implementation GGPushTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pushSwitch:(id)sender {
    UISwitch *uiSwitch=(UISwitch *)sender;
    BOOL isOn=[uiSwitch isOn];
    
    if (isOn) {
        NSLog(@"aaa");
        [self.delegate clickPush:self];
    }else{
        NSLog(@"off");
        [self.delegate clickNotPush:self];
    }
}
@end
