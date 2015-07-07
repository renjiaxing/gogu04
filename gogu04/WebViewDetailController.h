//
//  WebViewDetailController.h
//  gogu04
//
//  Created by 任佳星 on 15/6/1.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewDetailController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) NSString *url;
@end
