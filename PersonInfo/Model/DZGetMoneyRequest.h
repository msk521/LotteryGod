//
//  DZGetMoneyRequest.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/11.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZGetMoneyRequest : DZBaseRequestModel
//用户名
@property (nonatomic,copy) NSString *account;
//银行名称
@property (nonatomic,copy) NSString *bankName;
//银行卡号
@property (nonatomic,copy) NSString *bankCardNumber;
//持卡人姓名
@property (nonatomic,copy) NSString *bankRegisteredName;
//提现金额
@property (nonatomic,copy) NSString *amount;
@end
