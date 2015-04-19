//
//  GGMicropostFrame.m
//  gogu04
//
//  Created by ren on 15/4/1.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GGMicropostFrame.h"
#import "Micropost.h"
#import "NSString+Extension.h"

@implementation GGMicropostFrame

-(void)setMicropost:(Micropost *)micropost
{
    _micropost=micropost;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    
    /**正文*/
    CGFloat contentX=GGMicropostCellMargin;
    CGFloat contentY=GGMicropostCellBorderW;
    
    CGFloat maxW=cellW-2*contentX;
    CGSize contentSize=[micropost.content sizeWithContentFont:GGMicropostCellContentFont maxW:maxW];
    self.contentF=(CGRect){{contentX,contentY},{maxW,contentSize.height}};
    
    /**图片*/
    CGFloat timeY=0;
    if(![micropost.image isEqualToString:@""]){
        CGFloat imageX=cellW/2-50;
        CGFloat imageY=CGRectGetMaxY(self.contentF)+GGMicropostCellBorderW;
        self.imageF=CGRectMake(imageX, imageY, GGImageWidth, GGimageHeight);
        timeY=CGRectGetMaxY(self.imageF)+GGMicropostImage;
    }else{
        timeY=CGRectGetMaxY(self.contentF)+GGMicropostImage;
    }
    
    /**时间*/
    
    CGFloat timeX=GGMicropostCellMargin;
    CGSize timeSize=[micropost.created_at sizeWithFont:GGMicropostCellTimeFont maxW:maxW];
    self.timeF=(CGRect){{timeX,timeY},{maxW,timeSize.height}};
    
    /**股票*/
    CGFloat stockX=GGMicropostImage;
    CGFloat stockY=CGRectGetMaxY(self.timeF)+GGMicropostImage;
    CGSize stockSize=[micropost.stock_name sizeWithFont:GGMicropostCellTimeFont maxW:maxW];
    self.stockF=(CGRect){{stockX,stockY},{stockSize.width,stockSize.height}};
    
    
    /**修改*/
    CGFloat changeX=cellW-GGMicropostCellBorderW-GGIconW-GGIconMargin;
    CGFloat changeY=stockY;
    self.changeF=CGRectMake(changeX, changeY, GGIconW, GGIconW);
    
    /**删除*/
    CGFloat delX=changeX-GGIconW-GGIconMargin;
    CGFloat delY=stockY;
    self.delF=CGRectMake(delX, delY, GGIconW, GGIconW);
    
    /**私信*/
    CGFloat chatX=delX=delX-GGIconW-GGIconMargin;
    CGFloat chatY=stockY;
    self.chatF=CGRectMake(chatX, chatY, GGIconW, GGIconW);
    
    /**回复数*/
    CGFloat messageNumX=chatX-GGIconW-GGIconMargin;
    CGFloat messageNumY=stockY;
    self.messageNumF=CGRectMake(messageNumX, messageNumY, GGIconW, GGIconW);
    
    /**回复*/
    CGFloat messageX=messageNumX-GGIconW-GGIconMargin;
    CGFloat messageY=stockY;
    self.messageF=CGRectMake(messageX, messageY, GGIconW, GGIconW);
    
    /**点赞数*/
    CGFloat likeNumX=messageX-(GGIconMargin+GGIconW);
    CGFloat likeNumY=stockY;
    self.likeNumF=CGRectMake(likeNumX, likeNumY, GGIconW, GGIconW);
    
    /**点赞*/
    CGFloat likeX=likeNumX-GGIconW-GGIconMargin;
    CGFloat likeY=stockY;
    self.likeF=CGRectMake(likeX, likeY, GGIconW, GGIconW);
    
    self.cellHeight=CGRectGetMaxY(self.stockF)+GGMicropostCellMargin;
}

@end
