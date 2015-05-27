//
//  MessageBottomBar.h
//  gogu04
//
//  Created by ren on 15/5/22.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageBottomBar;
@protocol MessageBottomBarDelegate <NSObject>

-(void)clickSend:(MessageBottomBar *)bar;

@end

@interface MessageBottomBar : UIView
@property (weak, nonatomic) IBOutlet UITextField *messageContent;

@property(weak,nonatomic) id<MessageBottomBarDelegate> delegate;

- (IBAction)send:(id)sender;
+ (instancetype)messageBar;

@end
