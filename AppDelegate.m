//
//  AppDelegate.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/3.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "AppDelegate.h"
#import <Pingpp.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [Pingpp handleOpenURL:url
           withCompletion:^(NSString *result, PingppError *error) {
               if ([result isEqualToString:@"success"]) {
                   // 支付成功
               } else {
                   // 支付失败或取消
                   NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
               }
               [[NSNotificationCenter defaultCenter] postNotificationName:PayResult object:result];
           }];
    return  YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSUserDefaults *defaulters = [NSUserDefaults standardUserDefaults];
    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
    if (userInfoMation) {
        [DZUtile showAlertViewWithMessage:@"退出成功"];
        NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:userInfoMation];
        [defaulters setObject:data forKey:@"UserInfo"];
    }
    [defaulters synchronize];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSUserDefaults *defaulters = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaulters objectForKey:@"UserInfo"];
    if (data) {
        DZUserInfoMation *userInfoMation = [NSKeyedUnarchiver  unarchiveObjectWithData:data];
        [DZAllCommon shareInstance].userInfoMation = userInfoMation;
    }
     
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSUserDefaults *defaulters = [NSUserDefaults standardUserDefaults];
    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
    if (userInfoMation) {
        NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:userInfoMation];
        [defaulters setObject:data forKey:@"UserInfo"];
    }
    [defaulters synchronize];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
