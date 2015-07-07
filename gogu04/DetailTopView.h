//
//  DetailTopView.h
//  gogu03
//
//  Created by ren on 15/3/4.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Micropost.h"
#import "InsetsUILabel.h"

@class KILabel;
@interface DetailTopView : UIView
@property (strong,nonatomic) Micropost *micropost;
@property (nonatomic,assign) CGRect frame;
@property (weak,nonatomic) UIButton *stockButton;
//@property (weak,nonatomic) InsetsUILabel *contentLabel;
@property (weak,nonatomic) KILabel *contentLabel;
@property (weak,nonatomic) UIImageView *image;
@property (strong,nonatomic) UINavigationController *nc;
@end
