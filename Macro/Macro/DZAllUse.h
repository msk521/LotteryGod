//
//  VKAllUse.h
//  OldManChat
//
//  Created by 马士奎 on 15/9/29.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#ifndef OldManChat_VKAllUse_h
#define OldManChat_VKAllUse_h

#define COLOR(x,y,z) [UIColor colorWithRed:x/255.0f green:y/255.0f blue:z/255.0f alpha:1.0];
#define  DOCUMENT(imageName) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:imageName]

#define RESTLOTTYNAME @"restLottyName"
//用户余额改变
#define UserBlance @"UserBlance"
//支付结果
#define PayResult @"PayResult"
#pragma MARK:设置字段名
/**
 *  用户名
 */
#define USERNAME @"userName"
/**
 *  用户密码
 */
#define USERPASSWORD @"userPassword"
/**
 *  用户id
 */
#define USERID @"userId"

#define APPLICATION [UIApplication sharedApplication].delegate
#pragma MARK:POST与get宏

#define REQUEST_TYPE_GET @"GET"
#define REQUEST_TYPE_POST @"POST"
#define REQUEST_WEB_API @"requestApi"
#define kUrlScheme @"ahdzzfb0000"
#pragma mark--跳转到注册的输入用户信息页面
#define InputMyInfoIndentify @"InputMyInfoViewController"

#define iPhone6                                                                \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(750, 1334),                              \
[[UIScreen mainScreen] currentMode].size)           \
: NO)
#define iPhone6Plus                                                            \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(1242, 2208),                             \
[[UIScreen mainScreen] currentMode].size)           \
: NO)


#define IsIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0 ? YES : NO)
#endif
