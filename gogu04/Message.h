//
//  Message.h
//  gogu04
//
//  Created by ren on 15/5/20.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *fromuser_id;
@property(nonatomic,strong) NSString *touser_id;
@property(nonatomic,strong) NSString *created_at;
@property(nonatomic,strong) NSString *anonnum;
@property(nonatomic,strong) NSString *anontonum;
@property(nonatomic,strong) NSString *msg;
@end
