//
//  DZBettingViewController.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/8.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseViewController.h"
#import "DZLastWinNumberRespond.h"
@interface DZBettingViewController : DZBaseViewController
@property (nonatomic,strong) DZLastWinNumberRespond *currentRespond;
//剩余倒计时
@property (nonatomic,assign)int  resetTimer;
//分析条件
@property (nonatomic,copy) NSString *anlyesStr;
@end
