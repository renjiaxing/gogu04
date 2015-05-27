//
//  GGDropdownMenu.m
//  gogu04
//
//  Created by ren on 15/5/24.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGDropdownMenu.h"
#import "UIView+Extension.h"

@interface GGDropdownMenu() 

@property(nonatomic,weak) UIImageView *containerView;

@end

@implementation GGDropdownMenu

-(UIImageView *)containerView
{
    if(!_containerView)
    {
        UIImageView *containerView=[[UIImageView alloc] init];
        containerView.image=[UIImage imageNamed:@"popover_background"];
        containerView.userInteractionEnabled=YES;
        [self addSubview:containerView];
        self.containerView=containerView;
    }
    return _containerView;
}

-(void)setContent:(UIView *)content
{
    _content=content;
    
    content.x=10;
    content.y=14;
    
    
//    self.containerView.height=CGRectGetMaxY(content.frame)+10;
//    
//    self.containerView.width=self.containerView.width-2*content.x;
    
    self.containerView.height=CGRectGetMaxY(content.frame)+11;

    self.containerView.width=CGRectGetMaxX(content.frame)+10;
    
    [self.containerView addSubview:content];
}

-(void)setContentController:(UIViewController *)contentController
{
    _contentController=contentController;
    self.content=contentController.view;
    
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        
    }
    return self;
}

+(instancetype)menu
{
    return [[self alloc] init];
}

-(void)showFrom:(UIView *)from
{
    UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
    
    [window addSubview:self];
    
    self.frame=window.bounds;
    
    CGRect newFrame=[from convertRect:from.bounds toView:window];
    
    self.containerView.centerX=CGRectGetMidX(newFrame);
    
    self.containerView.y=CGRectGetMaxY(newFrame);
    
}

-(void)dismiss
{
    [self removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}

@end
