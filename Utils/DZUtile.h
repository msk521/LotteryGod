//
//  VKUtile.h
//  OldManChat
//
//  Created by 马士奎 on 15/9/29.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DZLoginViewController.h"
typedef  void (^LoadingLogingControllerFinished) ();
@interface DZUtile : NSObject

/**
 *  显示/隐藏登录
 *
 *  @param animation                       是否动画显示
 *  @param finishLoading                   显示结束
 *  @param LoadingLogingControllerFinished 隐藏结束
 */
+(void)showLoginViewController:(DZLoginViewController *)loginController animation:(BOOL)animation finishLoading:(LoadingLogingControllerFinished)finishLoading hiddenFinish:(LoadingLogingControllerFinished)hiddenFinish;

/**
 *  侧滑显示view
 *
 *  @param letController                   需要显示的左侧controoller
 *  @param finishLoading                   显示结束
 *  @param LoadingLogingControllerFinished 隐藏结束
 */
+(void)showLetfViewController:(UIViewController *)letController finishLoading:(LoadingLogingControllerFinished)finishLoading hiddenFinish:(LoadingLogingControllerFinished)LoadingLogingControllerFinished;

/**
 *  储存数据到本地
 *
 *  @param objc 要存储的数据
 *  @param key  存储数据key值
 */
+(void)saveSomeDataToUserDefaulter:(NSString *)objc forkey:(NSString *)key;
/**
 *  查询本地存储的数据
 *
 *  @param key 要查询数据的key值
 *
 *  @return 查询到的值
 */
+(NSString *)searchObjcFromUserDefaulter:(NSString *)key;
/**
 *  存储数据到plist文件中
 *
 *  @param dic 要存储的数据
 */
+(void)saveDataToFile:(NSDictionary *)dic withFileName:(NSString *)fileName;

/**
 *  从本地plist文件中获取数据
 *
 *  @param fileName 文件名
 *
 *  @return 返回数据
 */
+(NSDictionary *)receiveDataFromPlist:(NSString *)fileName;
/**
 *  弹出提示框
 *
 *  @param message 提示信息
 */
+(void)showAlertViewWithMessage:(NSString *)message;
/**
 *计算时间差多少秒
 *
 *  @param lastTime 传入需要计算的时间
 *
 *  @return 想差多少秒
 */
+(NSInteger)requestTimeMinusWith:(NSString *)lastTime;
/**
 *  存储用户数据
 */
+(void)saveData;
/**
 *  检测时间
 *
 *  @return
 */
+(BOOL)checkTime;

/**
 *  检测升级
 */
+(void)checkVersion:(id)delegate;
/**
 *  时间已过开奖时间时计算时差
 *
 *  @return
 */
+(int)checkMinus;
@end
