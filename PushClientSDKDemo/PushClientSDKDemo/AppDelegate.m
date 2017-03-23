//
//  AppDelegate.m
//  PushClientSDKDemo
//
//  Created by jeasonyoung on 2017/2/28.
//  Copyright © 2017年 Murphy. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "PushClientSDK.h"
#import "PushClientConfig.h"

@interface AppDelegate ()<PushClientSDKDelegate>{
    PushClientSDK *_pushSDK;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = [[ViewController alloc] init];
    [_window makeKeyAndVisible];
    
    //推送初始化
    _pushSDK = [PushClientSDK sharedInstance];
    _pushSDK.delegate = self;
    
    return YES;
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    @try {
        //Apple 推送设备令牌，启动推送服务
        [_pushSDK startHost:PUSH_HOST andAccount:PUSH_ACCOUNT andPassword:PUSH_TOKEN withDeviceToken:deviceToken];
    } @catch (NSException *exception) {
        NSLog(@"application:didRegisterForRemoteNotificationsWithDeviceToken-err=>%@", exception);
    }
}

#pragma mark -- 接收APNS消息开始
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    [_pushSDK receiveRemoteNotification:userInfo];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    [_pushSDK receiveRemoteNotification:userInfo];
    
}
#pragma mark -- 接收APNS消息结束


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


#pragma mark -- App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    @try{
        //应用进入后台,关闭推送服务
        [_pushSDK close];
    }@catch(NSException *e){
        NSLog(@"applicationDidEnterBackground-err=>%@", e);
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

#pragma mark -- App进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    @try{
        //应用进入前台,重启推送服务
        [_pushSDK restart];
    }@catch(NSException *e){
         NSLog(@"applicationWillEnterForeground-err=>%@", e);
    }
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -- PushClientSDKDelegate
-(void)pushClientSDK:(PushClientSDK *)sdk withErrorType:(PushClientSDKErrorType)type andMessageDesc:(NSString *)desc{
    NSLog(@"pushClientSDK-ERROR(%zd):\n%@", type, desc);
}

-(void)pushClientSDK:(PushClientSDK *)sdk withIsApns:(BOOL)isApns receivePushMessageTitle:(NSString *)title andMessageContent:(NSString *)content withFullPublish:(PushPublishModel *)data{
    
    
    NSLog(@"pushClientSDK(%p)[isAPNS:%zd]=>(title:%@)\n%@", sdk, isApns, title, content);
    
}

@end
