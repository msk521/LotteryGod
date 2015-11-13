//
//  DZGetMoneyRecordRespond.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/11.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseModel.h"

@interface DZGetMoneyRecordRespond : DZBaseModel
//用户名
@property (nonatomic,copy) NSString *amount;
//卡号
@property (nonatomic,copy) NSString *bankCardNumber;
//银行
@property (nonatomic,copy) NSString *bankName;
//持卡人姓名
@property (nonatomic,copy) NSString *bankRegisteredName;
//时间
@property (nonatomic,copy) NSString *createTime;
//状态
@property (nonatomic,copy) NSString *status;

@end
