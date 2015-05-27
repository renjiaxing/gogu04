//
//  DetailTopView.m
//  gogu03
//
//  Created by ren on 15/3/4.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "DetailTopView.h"
#import "GoGuTool.h"
#import "InsetsUILabel.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface DetailTopView() <UIGestureRecognizerDelegate>

@end

@implementation DetailTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        InsetsUILabel *contentLabel=[[InsetsUILabel alloc] initWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        contentLabel.font=[UIFont systemFontOfSize:18];
        contentLabel.numberOfLines=0;
//        contentLabel.backgroundColor=[UIColor greenColor];
        contentLabel.textAlignment=NSTextAlignmentCenter;
        contentLabel.backgroundColor=[UIColor colorWithRed:0 green:80/255.0 blue:60/255.0 alpha:1];
        contentLabel.textColor=[UIColor whiteColor];
        
        [self addSubview:contentLabel];
        self.contentLabel=contentLabel;
        
        UIButton *stockButton=[[UIButton alloc] init];
        stockButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [stockButton.layer setMasksToBounds:YES];
        [stockButton.layer setCornerRadius:10.0];
        [stockButton.layer setBorderWidth:1.0];
        [stockButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [stockButton addTarget:self action:@selector(clickStockButton) forControlEvents:UIControlEventTouchDown];
        [self addSubview:stockButton];
        self.stockButton=stockButton;
        
        
        
        
    }
    return self;
}

//-(void)clickStockButton
//{
//    MicropostsTableViewController *newVc = [[MicropostsTableViewController alloc] init];
//    newVc.stock_id = self.micropost.stock_id;
//    newVc.stock_name = self.micropost.stock_name;
//    
//    [self.navigationController pushViewController:newVc animated:YES];
//}


- (void)tapImage:(UITapGestureRecognizer *)tap
{
    NSLog(@"aaaa");
    int count = 1;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [NSString stringWithFormat:@"%@%@",SERV_URL,self.micropost.image];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = self.image; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setMicropost:(Micropost *)micropost
{
    _micropost=micropost;
    
    CGFloat contentX=0;
    CGFloat contentY=0;
    CGFloat maxW=[UIScreen mainScreen].bounds.size.width;
    CGSize maxSize=CGSizeMake(maxW, MAXFLOAT);
    CGSize contentSize=[self.micropost.content boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;

//    CGSize contentSize=[self.micropost.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:maxSize];
    self.contentLabel.text=micropost.content;
    if(contentSize.height<150){
        self.contentLabel.frame=CGRectMake(contentX, contentY, maxW, 150);
    }else{
        self.contentLabel.frame=CGRectMake(contentX, contentY, maxW, contentSize.height+20);
    }
    
    
    [self.stockButton setTitle:self.micropost.stock_name forState:UIControlStateNormal];
    
    CGFloat buttonX=MARGIN_CONTENT;
    
    CGFloat buttonH=BUTTON_HEIGHT;
    CGFloat buttonW=[UIScreen mainScreen].bounds.size.width-2*MARGIN_CONTENT;

    
    if (![micropost.image isEqualToString:@""]) {
        
        UIImageView *image=[[UIImageView alloc] init];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [image setClipsToBounds:YES];
        image.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        tap.numberOfTapsRequired=1;
//        tap.delegate=self;
        [image addGestureRecognizer:tap];
        [self addSubview:image];

        
        [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERV_URL,micropost.image]]];
        NSLog(@"imagepic:%@%@",SERV_URL,micropost.image);
        
        CGFloat imageX=0;
        CGFloat imageY=CGRectGetMaxY(self.contentLabel.frame)+MARGIN_SMALLCONTENT;
        CGFloat imageW=[UIScreen mainScreen].bounds.size.width;
        CGFloat imageH=100;

        self.image=image;
        self.image.frame=CGRectMake(imageX, imageY, imageW, imageH);
        
        CGFloat buttonY=CGRectGetMaxY(self.image.frame)+MARGIN_SMALLCONTENT;
        self.stockButton.frame=CGRectMake(buttonX, buttonY, buttonW, buttonH);

    }else{
        
        CGFloat buttonY=CGRectGetMaxY(self.contentLabel.frame)+MARGIN_SMALLCONTENT;
        self.stockButton.frame=CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
    

    CGFloat frameH=CGRectGetMaxY(self.stockButton.frame)+MARGIN_SMALLCONTENT;
    CGFloat frameX=0;
    CGFloat frameY=0;
    CGFloat frameW=[UIScreen mainScreen].bounds.size.width;
    
    self.frame=CGRectMake(frameX, frameY, frameW, frameH);
    
}
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}
//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    return YES;
//}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//
//}

@end
