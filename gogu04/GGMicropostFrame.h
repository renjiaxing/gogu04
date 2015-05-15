//
//  GGMicropostFrame.h
//  gogu04
//
//  Created by ren on 15/4/1.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 昵称字体
#define GGMicropostCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define GGMicropostCellTimeFont [UIFont systemFontOfSize:12]

// 股票字体
#define GGMicropostCellStockFont [UIFont systemFontOfSize:14]

// 来源字体
#define GGMicropostCellSourceFont GGMicropostCellTimeFont
// 正文字体
#define GGMicropostCellContentFont [UIFont systemFontOfSize:20]

// 被转发微博的正文字体
#define GGMicropostCellRetweetContentFont [UIFont systemFontOfSize:13]

// cell之间的间距
#define GGMicropostCellMargin 30

// cell的边框宽度
#define GGMicropostCellBorderW 30
#define GGMicropostImage 15

#define GGIconW 20

#define GGIconMargin 5

#define GGImageWidth 100
#define GGimageHeight 100

@class Micropost;
@interface GGMicropostFrame : NSObject

@property (nonatomic,strong) Micropost *micropost;

@property (nonatomic,assign) CGRect contentF;
@property (nonatomic,assign) CGRect imageF;
@property (nonatomic,assign) CGRect timeF;
@property (nonatomic,assign) CGRect stockF;
@property (nonatomic,assign) CGRect likeF;
@property (nonatomic,assign) CGRect likeNumF;
@property (nonatomic,assign) CGRect messageF;
@property (nonatomic,assign) CGRect messageNumF;
@property (nonatomic,assign) CGRect chatF;
@property (nonatomic,assign) CGRect delF;
@property (nonatomic,assign) CGRect changeF;

@property (nonatomic,assign) CGFloat cellHeight;

@end
