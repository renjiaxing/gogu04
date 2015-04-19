//
//  GoGuTool.m
//  gogu04
//
//  Created by ren on 15/3/31.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "GoGuTool.h"

@implementation GoGuTool

-(BOOL)validateEmail:(NSString *)candidate
{
    NSString *Regex=@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailText=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    return [emailText evaluateWithObject:candidate];
    
}
@end
