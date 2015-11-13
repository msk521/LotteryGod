//
//  DZBuyLottery.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/27.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZBuyLottery : DZBaseRequestModel
//用户名
@property (nonatomic,copy) NSString *account;
//投注信息
@property (nonatomic,strong) NSArray *details;
@end
