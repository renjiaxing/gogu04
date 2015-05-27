//
//  GGDropdownMenu.h
//  gogu04
//
//  Created by ren on 15/5/24.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GGDropdownMenu;
@protocol GGDropdownMenuDelegate <NSObject>

@optional
-(void)dropdownMenuDidDismiss:(GGDropdownMenu *)menu;

@end
@interface GGDropdownMenu : UIView

@property(nonatomic,weak) id<GGDropdownMenuDelegate> delegate;
+(instancetype)menu;

-(void)showFrom:(UIView *)from;

-(void)dismiss;

@property (nonatomic,strong) UIView *content;
@property (nonatomic,strong) UIViewController *contentController;
@end
