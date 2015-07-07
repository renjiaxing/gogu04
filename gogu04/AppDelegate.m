//
//  AppDelegate.m
//  gogu04
//
//  Created by ren on 15/3/31.
//  Copyright (c) 2015年 ren. All rights reserved.
//

#import "AppDelegate.h"
#import "GGTabBarViewController.h"
#import "GGLoginViewController.h"
#import "GoGuTool.h"
#import "AFNetworking.h"
#import "XGPush.h"
#import "XGSetting.h"

@interface AppDelegate ()
@property(nonatomic,strong) NSData *deviceToken;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window=[[UIWindow alloc] init];
    self.window.frame=[UIScreen mainScreen].bounds;
    
    [WXApi registerApp:@"wx184f80b52d0ec155" withDescription:@"gogu 1.1"];
    
    
    
    [XGPush startApp:2200120344 appKey:@"I9J5P558EQAD"];
    //[XGPush startApp:2290000353 appKey:@"key1"];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //[XGPush registerPush];  //注册Push服务，注册后才能收到推送
    
    
    //推送反馈(app不在前台运行时，点击推送激活时)
    //[XGPush handleLaunching:launchOptions];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //清除所有通知(包含本地通知)
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *user_id=[defaults objectForKey:@"user_id"];
    NSString *token=[defaults objectForKey:@"token"];
    
    
    
    NSLog(@"user_id %@ , token %@",user_id,token);
    if( !OBJ_IS_NIL(user_id) && !OBJ_IS_NIL(token)){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *param=[NSMutableDictionary dictionary];
        param[@"uid"]=user_id;
        param[@"token"]=token;
        [manager GET:LOGIN_TOKEN_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *result=responseObject[@"result"];
            if ([result isEqualToString:@"ok"]) {
                
                NSString *account=[NSString stringWithFormat:@"account%@",user_id];
                NSLog(@"%@",account);
                
                [XGPush setAccount:account];
                
                void (^successBlock)(void) = ^(void){
                    //成功之后的处理
                    NSLog(@"[XGPush]register successBlock");
                };
                
                void (^errorBlock)(void) = ^(void){
                    //失败之后的处理
                    NSLog(@"[XGPush]register errorBlock");
                };
                
                //注册设备
                //    [[XGSetting getInstance] setChannel:@"appstore"];
                //    [[XGSetting getInstance] setGameServer:@"巨神峰"];
                
                
                if (self.deviceToken!=nil) {
                    NSString * deviceTokenStr = [XGPush registerDevice:self.deviceToken successCallback:successBlock errorCallback:errorBlock];
                    
                    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
                }

                
                self.window.rootViewController=[[GGTabBarViewController alloc] init];
            }else{
                GGLoginViewController *loginVc=[[GGLoginViewController alloc] init];
//                loginVc.deviceToken=self.deviceToken;
                UINavigationController *loginNav=[[UINavigationController alloc] initWithRootViewController:loginVc];
                self.window.rootViewController=loginNav;
            }
//            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            GGLoginViewController *loginVc=[[GGLoginViewController alloc] init];
            UINavigationController *loginNav=[[UINavigationController alloc] initWithRootViewController:loginVc];
            self.window.rootViewController=loginNav;
//            NSLog(@"Error: %@", error);
        }];
    }else{        
        GGLoginViewController *loginVc=[[GGLoginViewController alloc] init];
        UINavigationController *loginNav=[[UINavigationController alloc] initWithRootViewController:loginVc];
        self.window.rootViewController=loginNav;
    }
    
    

    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    self.deviceToken=deviceToken;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceToken forKey:@"deviceToken"];
    [defaults synchronize];
    
//    NSLog(<#NSString *format, ...#>)
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    //注册设备
//    [[XGSetting getInstance] setChannel:@"appstore"];
//    [[XGSetting getInstance] setGameServer:@"巨神峰"];
    
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"%@",str);
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    
    NSLog(@"%@",userInfo);
    //回调版本示例
    /*
     void (^successBlock)(void) = ^(void){
     //成功之后的处理
     NSLog(@"[XGPush]handleReceiveNotification successBlock");
     };
     
     void (^errorBlock)(void) = ^(void){
     //失败之后的处理
     NSLog(@"[XGPush]handleReceiveNotification errorBlock");
     };
     
     void (^completion)(void) = ^(void){
     //失败之后的处理
     NSLog(@"[xg push completion]userInfo is %@",userInfo);
     };
     
     [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
     */
}


@end
