//
//  GGMessageFrame.h
//  gogu04
//
//  Created by ren on 15/5/20.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Message;
@interface GGMessageFrame : NSObject

@property(nonatomic,assign)CGRect timeF;
@property(nonatomic,assign)CGRect textViewF;
@property(nonatomic,assign)CGRect iconF;
@property(nonatomic,assign)CGFloat cellH;

@property(nonatomic,strong)Message *message;

@end
