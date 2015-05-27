//
//  GGMessageFrame.m
//  gogu04
//
//  Created by ren on 15/5/20.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGMessageFrame.h"
#import "GoGuTool.h"
#import "Message.h"

@interface GGMessageFrame()

@property(strong,nonatomic) NSString *user_id;

@end

@implementation GGMessageFrame

-(void)setMessage:(Message *)message
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.user_id=[defaults objectForKey:@"user_id"];
    

    _message=message;
    
    CGFloat padding=10;
    
    CGFloat timeX=0;
    CGFloat timeY=0;
    CGFloat timeW=CELLH;
    CGFloat timeH=NORMALH;
    
    _timeF=CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat iconX;
    CGFloat iconY=CGRectGetMaxY(_timeF);
    CGFloat iconW=ICONW;
    CGFloat iconH=ICONH;
    
    if ([self.message.fromuser_id intValue]==[self.user_id intValue]) {
        iconX=CELLH-ICONW-padding;
    }else{
        iconX=padding;
    }
    
    _iconF=CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat textX;
    CGFloat textY= iconY+padding;
//    CGFloat textW=;
//    CGFloat textH=;
    
    CGSize textMaxSize=CGSizeMake(CELLH-ICONW*2-padding*2, MAXFLOAT);
    
    CGSize textRealSize=[self.message.msg boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:MESSAGETEXTFONT} context:nil].size;
    
    CGSize btnSize=CGSizeMake(textRealSize.width+40, textRealSize.height+40);
    
    if ([self.message.fromuser_id intValue]==[self.user_id intValue]) {
        textX=CELLH-ICONW-padding*2-btnSize.width;
    }else{
        textX=padding*2+ICONW;
    }
    
    _textViewF=(CGRect){{textX,textY},btnSize};
    
    CGFloat iconMaxY=CGRectGetMaxY(_iconF);
    CGFloat textMaxY=CGRectGetMaxY(_textViewF);
    
    _cellH=MAX(iconMaxY,textMaxY);
    
}

@end
