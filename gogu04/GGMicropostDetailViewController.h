//
//  GGMicropostDetailViewController.h
//  gogu04
//
//  Created by ren on 15/4/14.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Micropost;

@interface GGMicropostDetailViewController : UIViewController
//@property (strong,nonatomic) NSNumber *micropost_id;
@property (strong,nonatomic) Micropost *micropost;
@end
