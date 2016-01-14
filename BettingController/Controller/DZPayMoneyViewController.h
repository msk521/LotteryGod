//
//  DZPayMoneyViewController.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/20.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseViewController.h"

@interface DZPayMoneyViewController : DZBaseViewController
//提交参数
@property (nonatomic,strong) NSDictionary *commitDic;
//应付金额
@property (nonatomic,strong) NSString *shouldPayMoney;
//当前期数
@property (nonatomic,strong) NSString *currentPoidPayMoney;
//购买情况
@property (nonatomic,strong) NSString *buyInfo;
@end
