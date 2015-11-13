//
//  DZLastWinNumberRespond.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/18.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseModel.h"
@interface DZLastWinNumberRespond : DZBaseModel
/**
 *  彩种类型
 */
@property (nonatomic,copy) NSString *type;
/**
 *  最后一期，期号
 */
@property (nonatomic,copy) NSString *period;
/**
 *  最后一期中奖号码
 */
@property (nonatomic,copy) NSString *numbers;
/**
 *  最后一期的开奖时间
 */
@property (nonatomic,copy) NSString *time;
/**
 *  最后一期开奖时间后台获取的时间
 */
@property (nonatomic,copy) NSString *receiveTime;
@end
