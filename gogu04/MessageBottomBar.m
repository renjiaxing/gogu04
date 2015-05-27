//
//  MessageBottomBar.m
//  gogu04
//
//  Created by ren on 15/5/22.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "MessageBottomBar.h"

@implementation MessageBottomBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)send:(id)sender {
    [self.delegate clickSend:self];
}

+(instancetype)messageBar
{
    return [[[NSBundle mainBundle] loadNibNamed:@"MessageBottomBar" owner:nil options:nil] lastObject];
}

@end
