//
//  InsetsUILabel.h
//  gogu03
//
//  Created by ren on 15/3/4.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetsUILabel : UILabel
-(id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets) insets;
-(id)initWithInsets:(UIEdgeInsets) insets;
@end
