//
//  HistoricalTrendViewController.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/3.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseViewController.h"
#import "DZLastWinNumberRespond.h"
@interface HistoricalTrendViewController : DZBaseViewController
@property(nonatomic,strong) DZLastWinNumberRespond *lstWinNum;
@property (nonatomic,copy) NSString *currentTime;

@end
