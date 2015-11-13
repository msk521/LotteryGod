//
//  DZGenralQuery.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/28.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZGenralQuery : DZBaseRequestModel
//总钱数
@property (nonatomic,copy) NSString *principal;
//盈利钱数
@property (nonatomic,copy) NSString *profit;
//倍数
@property (nonatomic,copy) NSString *multiple;
//倍率
@property (nonatomic,copy) NSString *rate;
//期数
@property (nonatomic,copy) NSString *periods;
@end
