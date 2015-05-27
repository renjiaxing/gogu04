//
//  GoGuTool.h
//  gogu04
//
//  Created by ren on 15/3/31.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>
// RGB颜色
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define OBJ_IS_NIL(s) (s==nil || [s isKindOfClass:[NSNull class]])

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define MARGIN_CONTENT 10
#define MARGIN_SMALLCONTENT 5
#define BUTTON_HEIGHT 35

// 全局背景色
#define HMGlobalBg HMColor(211, 211, 211)
#define HMStatusCellMargin 10

//#define SERV_URL @"http://121.41.25.221"

#define SERV_URL @"http://127.0.0.1:3000"
#define MICROPOSTS_URL [NSString stringWithFormat:@"%@/apijson/microposts_json",SERV_URL]
#define DOWN_MICROPOSTS_URL [NSString stringWithFormat:@"%@/apijson/down_microposts_json",SERV_URL]
#define UP_MICROPOSTS_URL [NSString stringWithFormat:@"%@/apijson/up_microposts_json",SERV_URL]
#define LOGIN_TOKEN_URL [NSString stringWithFormat:@"%@/apijson/login_token_json",SERV_URL]
#define LOGIN_URL [NSString stringWithFormat:@"%@/apijson/login_json",SERV_URL]
#define GOOD_MICROPOST_URL [NSString stringWithFormat:@"%@/micropost_good_json",SERV_URL]
#define NOGOOD_MICROPOST_URL [NSString stringWithFormat:@"%@/micropost_nogood_json",SERV_URL]
#define DETAIL_MICROPOST_URL [NSString stringWithFormat:@"%@/apijson/detail_micropost_json",SERV_URL]
#define COMMENT_PIC_URL [NSString stringWithFormat:@"%@/user_pic/",SERV_URL]
#define NEW_COMMENT_URL [NSString stringWithFormat:@"%@/apijson/new_comment_json",SERV_URL]
#define CHECK_STOCK_URL [NSString stringWithFormat:@"%@/stock_json",SERV_URL]
#define NEW_MICROPOST_URL [NSString stringWithFormat:@"%@/apijson/new_micropost_json",SERV_URL]
#define NEW_ADVICE_URL [NSString stringWithFormat:@"%@/apijson/new_advice_json",SERV_URL]
#define CHANGE_PASSWORD_URL [NSString stringWithFormat:@"%@/apijson/change_password_json",SERV_URL]
#define DEL_MICROPOST_URL [NSString stringWithFormat:@"%@/micropost_del_json",SERV_URL]
#define CHANGE_MICROPOST_URL [NSString stringWithFormat:@"%@/apijson/change_micropost_json",SERV_URL]
#define FORGET_PASSWORD_URL [NSString stringWithFormat:@"%@/apijson/forget_password_json",SERV_URL]
#define REG_URL [NSString stringWithFormat:@"%@/apijson/reg_json",SERV_URL]
#define DEL_COMMENT_URL [NSString stringWithFormat:@"%@/apijson/del_comment_json",SERV_URL]
#define MESSAGES_URL [NSString stringWithFormat:@"%@/messages_json",SERV_URL]
#define NEW_MESSAGE_URL [NSString stringWithFormat:@"%@/new_message_json",SERV_URL]
#define MY_MESSAGE_URL [NSString stringWithFormat:@"%@/message_user_json",SERV_URL]

#define CELLH [[UIScreen mainScreen] bounds].size.width
#define NORMALH 44
#define ICONW 50
#define ICONH 50

#define MESSAGETEXTFONT [UIFont systemFontOfSize:15.0f]

@interface GoGuTool : NSObject
-(BOOL)validateEmail:(NSString *)candidate;
@end
