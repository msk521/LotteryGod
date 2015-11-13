//
//  DZResult.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/6.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseModel.h"

@interface DZResult : DZBaseModel
//期数
@property (nonatomic,copy) NSString *resultDateNum;
//中奖号码
@property (nonatomic,copy) NSString *resultNumber;
//时间
@property (nonatomic,copy) NSString *resultTime;
@end
