//
//  GGMicropostCell.m
//  gogu04
//
//  Created by ren on 15/4/1.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGMicropostCell.h"
#import "GGMicropostFrame.h"
#import "Micropost.h"
#import "UIImageView+WebCache.h"
#import "GoGuTool.h"

@interface GGMicropostCell()
@property(strong,nonatomic) NSString *user_id;
@property(strong,nonatomic) NSString *token;
@end

@implementation GGMicropostCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"micropost";
    GGMicropostCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[GGMicropostCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化原创微博
        [self setupMicropost];

    }
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.user_id=[defaults objectForKey:@"user_id"];
    self.token=[defaults objectForKey:@"token"];
    
    return self;
}

-(void)setupMicropost
{
    UIView *micropostView=[[UIView alloc] init];
    micropostView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:micropostView];
    self.micropostView=micropostView;
    
    UILabel *contentLabel=[[UILabel alloc] init];
    contentLabel.font=GGMicropostCellContentFont;
    contentLabel.numberOfLines=4;
    contentLabel.textAlignment=NSTextAlignmentCenter;
    [micropostView addSubview:contentLabel];
    self.contentLabel=contentLabel;
    
    UIImageView *picView=[[UIImageView alloc] init];
    [micropostView addSubview:picView];
    self.picView=picView;
    
    UILabel *timeLabel=[[UILabel alloc] init];
    timeLabel.font=GGMicropostCellTimeFont;
    timeLabel.textColor=[UIColor lightGrayColor];
    timeLabel.textAlignment=NSTextAlignmentCenter;
    [micropostView addSubview:timeLabel];
    self.timeLabel=timeLabel;

    
    UIButton *stockButton=[[UIButton alloc] init];
    stockButton.userInteractionEnabled=YES;
//    stockButton.tag=@"stockButton";
//    [stockButton addTarget:self action:@selector(stockClick) forControlEvents:UIControlEventTouchUpInside];
    [micropostView addSubview:stockButton];
    self.stockButton=stockButton;
    
    UIButton *likeButton=[[UIButton alloc] init];
    [micropostView addSubview:likeButton];
    self.likeButton=likeButton;
    
    UILabel *likenumLabel=[[UILabel alloc] init];
    [micropostView addSubview:likenumLabel];
    self.likenumLabel=likenumLabel;
    
    UIButton *msgButton=[[UIButton alloc] init];
    [micropostView addSubview:msgButton];
    self.msgButton=msgButton;
    
    UILabel *msgnumLabel=[[UILabel alloc] init];
    [micropostView addSubview:msgnumLabel];
    self.msgnumLabel=msgnumLabel;
    
//    UIButton *chatButton=[[UIButton alloc] init];
//    [micropostView addSubview:chatButton];
//    self.chatButton=chatButton;
    
    UIButton *changeButton=[[UIButton alloc] init];
    [micropostView addSubview:changeButton];
    self.changeButton=changeButton;
    
    UIButton *delButton=[[UIButton alloc] init];
    [micropostView addSubview:delButton];
    self.delButton=delButton;
    
}

//-(void)stockClick
//{
//    NSLog(@"aaa");
//}

-(void)setMicropostFrame:(GGMicropostFrame *)micropostFrame
{
    _micropostFrame=micropostFrame;
    
    Micropost *micropost=micropostFrame.micropost;
    
    self.contentLabel.frame= micropostFrame.contentF;
    self.contentLabel.text=micropost.content;
    
    if (micropost.image) {
        self.picView.frame=micropostFrame.imageF;
        [self.picView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERV_URL,micropost.image]] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
        self.picView.hidden=NO;
    }else{
        self.picView.hidden=YES;
    }
    
    self.timeLabel.frame=micropostFrame.timeF;
    self.timeLabel.text=micropost.created_at;
    
    self.stockButton.frame=micropostFrame.stockF;
    self.stockButton.titleLabel.font=GGMicropostCellTimeFont;

    [self.stockButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.stockButton setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [self.stockButton setBackgroundImage:[UIImage imageNamed:@"compose_toolbar_background"] forState:UIControlStateHighlighted];
    [self.stockButton setTitle:micropost.stock_name forState:UIControlStateNormal];
    self.stockButton.userInteractionEnabled=YES;

    
    self.likeButton.frame=micropostFrame.likeF;
    self.likeButton.titleLabel.text=@"like";
    if([self.micropostFrame.micropost.good isEqualToString:@"false"]){
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"ic_card_like_grey"] forState:UIControlStateNormal];
    }else{
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"ic_card_liked"] forState:UIControlStateNormal];
    }
    
    
    self.likenumLabel.frame=micropostFrame.likeNumF;
    self.likenumLabel.text=[NSString stringWithFormat:@"%@",micropost.good_number];

    self.msgButton.frame=micropostFrame.messageF;
    self.msgButton.titleLabel.text=@"msg";
    [self.msgButton setBackgroundImage:[UIImage imageNamed:@"reply30"] forState:UIControlStateNormal];
    
    self.msgnumLabel.frame=micropostFrame.messageNumF;
    self.msgnumLabel.text=[NSString stringWithFormat:@"%@",micropost.comment_number];
    
//    self.chatButton.frame=micropostFrame.chatF;
//    self.chatButton.titleLabel.text=@"chat";
//    [self.chatButton setBackgroundImage:[UIImage imageNamed:@"sixin30"] forState:UIControlStateNormal];
////    self.chatButton.backgroundColor=[UIColor redColor];
//    NSLog(@"%f,%f",self.chatButton.frame.origin.x,self.chatButton.frame.origin.y);
    
    
    if ([self.user_id intValue]==micropost.user_id.intValue) {
        
        self.delButton.enabled=YES;
        self.changeButton.enabled=YES;
        
        self.delButton.frame=micropostFrame.delF;
        self.delButton.titleLabel.text=@"del";
        [self.delButton setBackgroundImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
        
        self.changeButton.frame=micropostFrame.changeF;
        self.changeButton.titleLabel.text=@"ch";
        [self.changeButton setBackgroundImage:[UIImage imageNamed:@"change48"] forState:UIControlStateNormal];
    }else{
        self.delButton.enabled=NO;
        self.delButton.frame=CGRectMake(0, 0, 0, 0);
        self.changeButton.enabled=NO;
        self.changeButton.frame=CGRectMake(0, 0, 0, 0);
    }


    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
