//
//  Comment.h
//  gogu03
//
//  Created by ren on 15/3/3.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Comment : NSObject
@property (strong,nonatomic) NSNumber *id;
@property (copy,nonatomic) NSString *msg;
@property (copy,nonatomic) NSString *created_at;
@property (strong,nonatomic) NSNumber *anonid;
@property (strong,nonatomic) NSString *user_id;
@end
