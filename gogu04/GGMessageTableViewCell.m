//
//  GGMessageTableViewCell.m
//  gogu04
//
//  Created by ren on 15/5/20.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGMessageTableViewCell.h"
#import "GGMessageFrame.h"
#import "Message.h"
#import "UIImageView+WebCache.h"
#import "GoGuTool.h"

@interface GGMessageTableViewCell()
@property(nonatomic,weak)UILabel *time;
@property(nonatomic,weak)UIButton *textView;
@property(nonatomic,weak)UIImageView *icon;

@end

@implementation GGMessageTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *time=[[UILabel alloc] init];
        [self.contentView addSubview:time];
        time.textAlignment=NSTextAlignmentCenter;
        time.font=[UIFont systemFontOfSize:13.0f];
        self.time=time;
        
        UIButton *textView=[[UIButton alloc] init];
        textView.titleLabel.font=MESSAGETEXTFONT;
        textView.titleLabel.numberOfLines=0;
        [textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        textView.contentEdgeInsets=UIEdgeInsetsMake(20, 20, 20, 20);
        [self.contentView addSubview:textView];
        self.textView=textView;
        
        UIImageView *icon=[[UIImageView alloc] init];
        [self.contentView addSubview:icon];
        self.icon=icon;
        
        self.backgroundColor=[UIColor clearColor];
    }
    
    return self;
}

-(void)setMessageFrame:(GGMessageFrame *)messageFrame
{
    _messageFrame=messageFrame;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.user_id=[defaults objectForKey:@"user_id"];
    
    self.time.frame=messageFrame.timeF;
    self.time.text=messageFrame.message.created_at;
    
    self.icon.frame=messageFrame.iconF;
    int num_temp;
    if ([self.user_id intValue]==[messageFrame.message.fromuser_id intValue]) {
        num_temp=self.randint;
    }else{
        num_temp=(self.randint+self.messageFrame.message.anontonum.intValue)%100;
    }
    
    [self.icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d.png",COMMENT_PIC_URL,num_temp]]placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    self.textView.frame=messageFrame.textViewF;
    [self.textView setTitle:messageFrame.message.msg forState:UIControlStateNormal];
    
    if ([self.user_id intValue]==[messageFrame.message.fromuser_id intValue]) {
        [self.textView setBackgroundImage:[self resizeWithImageName:@"chat_send_nor"] forState:UIControlStateNormal];
    }else{
        [self.textView setBackgroundImage:[self resizeWithImageName:@"chat_recive_nor"] forState:UIControlStateNormal];
    }
    
}

-(UIImage *)resizeWithImageName:(NSString *)name
{
    UIImage *nomal=[UIImage imageNamed:name];
    CGFloat w=nomal.size.width*0.5f-1;
    CGFloat h=nomal.size.height*0.5f-1;
    
    return [nomal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

+ (instancetype)messageCellWithTableView:(UITableView *)tableView
{
    static NSString *ID=@"messageCell";
    GGMessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[GGMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
