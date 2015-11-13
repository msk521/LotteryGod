//
//  DZSeniorChaseNumberViewController.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/28.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseViewController.h"

@interface DZSeniorChaseNumberViewController : DZBaseViewController
//模式
@property (nonatomic,copy) NSString *parent;
//起始倍数
@property (nonatomic,copy) NSString *startBeiShu;
//追号多少期
@property (nonatomic,copy) NSString *poids;
//倍率
@property (nonatomic,copy) NSString *rate;
//总价钱
@property (nonatomic,copy) NSString *totalMoney;
//共选多少注
@property (nonatomic,assign) int totalCount;
//所选号码
@property (nonatomic,strong) NSArray *selectedArr;
@end
