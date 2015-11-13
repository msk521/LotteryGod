//
//  DZFPTop.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/6.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseModel.h"

@interface DZFPTop : DZBaseModel
//开奖号码
@property (nonatomic,copy) NSString *winNumber;
//下期开奖时间
@property (nonatomic,copy) NSString *nextTime;
//用户金额
@property (nonatomic,copy) NSString *userMoney;
//用户排名
@property (nonatomic,copy) NSString *userRange;


@end
