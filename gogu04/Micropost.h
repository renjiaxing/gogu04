//
//  Micropost.h
//  gogu03
//
//  Created by ren on 15/2/26.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Micropost : NSObject
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) NSNumber *id;
@property (copy,nonatomic) NSString *created_at;
@property (copy,nonatomic) NSString *updated_at;
@property (strong,nonatomic) NSNumber *user_id;
@property (copy,nonatomic) NSString *stock_name;
@property (copy,nonatomic) NSString *stock_full_name;
@property (copy,nonatomic) NSString *good;
@property (strong,nonatomic) NSNumber *good_number;
@property (strong,nonatomic) NSNumber *comment_number;
@property (copy,nonatomic) NSString *image;
@property (strong,nonatomic) NSNumber *stock_id;
@property (strong,nonatomic) NSNumber *randint;
@property (strong,nonatomic) NSString *unread;
@end
