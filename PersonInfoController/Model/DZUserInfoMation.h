//
//  DZUserInfoMation.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/21.
//  Copyright (c) 2015年 DZ. All rights reserved.
//account = 15375419107;


#import "DZBaseModel.h"

@interface DZUserInfoMation : DZBaseModel<NSCoding>
//用户名
@property (nonatomic,copy) NSString *account;
//id
@property (nonatomic,copy) NSString *idNumber;
//真实名称
@property (nonatomic,copy) NSString *name;
//性别
@property (nonatomic,copy) NSString *sex;
//生日
@property (nonatomic,copy) NSString *birthday;
//电话号码
@property (nonatomic,copy) NSString *phone;
//qq
@property (nonatomic,copy) NSString *qq;
//email
@property (nonatomic,copy) NSString *email;
//余额
@property (nonatomic,copy) NSString *balance;
//积分
@property (nonatomic,copy) NSString *score;
//密码
@property (nonatomic,copy) NSString *password;
@end
