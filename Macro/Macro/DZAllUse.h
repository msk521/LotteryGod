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
//升级地址
#define UPDATEURL @"itms-services://?action=download-manifest&url=https://dn-lotterygod.qbox.me/LotteryGodNewBLUpdate.plist"
//友盟
#define UMENKEY @"56641b0367e58e8eac003cd7"
//投注截至时间要少于开奖时间多少秒
#define MINUES 160
//#define UPDATEURL @"itms-services://?action=download-manifest&url=https://dn-lotterygod.qbox.me/LotteryGod.plist"
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

#define WECHATKEY @"wx848ef9f084d35905"
#define AppSecret @"d4624c36b6795d1d99dcf0547af5443d"
//计算字符串的大小
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define DZ_Calculate_StringSize(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define DZ_Calculate_StringSize(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

#define APPLICATION [UIApplication sharedApplication].delegate
#pragma MARK:POST与get宏

#define REQUEST_TYPE_GET @"GET"
#define REQUEST_TYPE_POST @"POST"
#define REQUEST_WEB_API @"requestApi"
#define kUrlScheme @"wx848ef9f084d35905"
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
