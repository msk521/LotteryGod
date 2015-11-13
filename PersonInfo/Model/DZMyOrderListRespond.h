//
//  DZMyOrderListRespond.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/1.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseModel.h"

@interface DZMyOrderListRespond : DZBaseModel
//订单号
@property (nonatomic,copy) NSString *id;
//当前期数
@property (nonatomic,copy) NSString *currentPeriod;
//共多少期
@property (nonatomic,copy) NSString *totalPeriods;
//当前期
@property (nonatomic,copy) NSString *currentPeriodIndex;
//要取消的期数
@property (nonatomic,copy) NSString *cancelPeriods;
//共盈利
@property (nonatomic,copy) NSString *totalProfit;
//购彩时间
@property (nonatomic,copy) NSString *createTime;
//购买模式
@property (nonatomic,copy) NSString *pattern;
//彩种
@property (nonatomic,copy) NSString *lotteryName;
//彩票组
@property (nonatomic,copy) NSString *lotteryGroup;
//是否结束
@property (nonatomic,copy) NSString *finished;
//共支付
@property (nonatomic,copy) NSString *totalPrincipal;
//详情
@property (nonatomic,strong) NSArray *details;
//是否可以撤销 0不可以 1可以
@property (nonatomic,assign) int autoCancelOrderWhenWinning;
//订单状态
@property (nonatomic,copy) NSString *status;
@end
