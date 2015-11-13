//
//  DZIncomeStatement.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/9.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseModel.h"

@interface DZIncomeStatement : DZBaseModel
/**
 *  项目
 */
@property (nonatomic,copy) NSString *article;
/**
 *  金额
 */
@property (nonatomic,copy) NSString *amount;
/**
 *  剩余金额
 */
@property (nonatomic,copy) NSString *balance;
/**
 *  时间
 */
@property (nonatomic,copy) NSString *time;
/**
 *  充值还是付款
 */
@property (nonatomic,copy) NSString *action;
@end
