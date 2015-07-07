//
//  Stock.h
//  gogu03
//
//  Created by ren on 15/3/24.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stock : NSObject
@property (strong,nonatomic) NSNumber *id;
@property (copy,nonatomic) NSString *created_at;
@property (copy,nonatomic) NSString *updated_at;
@property (copy,nonatomic) NSString *code;
@property (copy,nonatomic) NSString *name;
@property (copy,nonatomic) NSString *shortname;
@property (copy,nonatomic) NSString *follow;
@end
