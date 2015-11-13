//
//  AppDelegate.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/3.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZLastWinNumberRespond.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) DZLastWinNumberRespond *currentRespond;
@property (nonatomic,copy) NSString *currentTime;
//是否请求最后一次开奖时间当程序打开
@property (nonatomic,assign) BOOL shouldAgainRequestWinNumber;
@end

