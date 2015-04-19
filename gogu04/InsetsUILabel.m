//
//  InsetsUILabel.m
//  gogu03
//
//  Created by ren on 15/3/4.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "InsetsUILabel.h"

@interface InsetsUILabel()
@property (assign,nonatomic) UIEdgeInsets insets;
@end

@implementation InsetsUILabel

- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets
{
    self = [super initWithFrame:frame];
    if (self) {
        self.insets=insets;
    }
    return self;
}

-(id)initWithInsets:(UIEdgeInsets)insets
{
    self=[super init];
    if(self){
        self.insets=insets;
    }
    return self;
}

-(void)drawTextInRect:(CGRect)rect
{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}


@end
