//
//  DetailMicropost.h
//  gogu03
//
//  Created by ren on 15/3/3.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailMicropost : NSObject
@property (strong,nonatomic) NSNumber *id;
@property (copy,nonatomic) NSString *content;
@property (copy,nonatomic) NSString *created_at;
@property (copy,nonatomic) NSString *image;
@property (strong,nonatomic) NSNumber *anonnum;
@property (strong,nonatomic) NSNumber *randint;
@end
