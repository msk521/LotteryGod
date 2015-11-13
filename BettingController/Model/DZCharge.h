//
//  DZCharge.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/22.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZCharge : DZBaseRequestModel
//手机号
@property (nonatomic,copy) NSString *account;
//付款方式
@property (nonatomic,copy) NSString *channel;
//金额
@property (nonatomic,copy) NSString *amount;
@end
