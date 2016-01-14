//
//  DZShouldBuyViewController.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/27.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseViewController.h"

@interface DZShouldBuyViewController : DZBaseViewController
//共多少钱
@property (nonatomic,copy) NSString *money;
//共多少注
@property (nonatomic,copy) NSString *totalCount;
//已选
@property (nonatomic,strong) NSArray *selectedArr;
//每注多少钱
@property (nonatomic,copy) NSString *howMoney;
//当前期数
@property (nonatomic,copy) NSString *currentPoids;
//是否是从查看分析结果过来的
@property (nonatomic,assign) BOOL isLookResult;
//数据分析条件
@property (nonatomic,copy) NSString *anlyesStr;
@end
