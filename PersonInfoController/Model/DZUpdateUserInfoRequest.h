//
//  DZUpdateUserInfoRequest.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/5.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZUpdateUserInfoRequest : DZBaseRequestModel
//用户名
@property (nonatomic,copy) NSString *account;
//id
@property (nonatomic,copy) NSString *idNumber;
//真实名称
@property (nonatomic,copy) NSString *name;
//性别
@property (nonatomic,assign) int sex;
//生日
@property (nonatomic,copy) NSString *birthday;
//电话号码
@property (nonatomic,copy) NSString *phone;
//qq
@property (nonatomic,copy) NSString *qq;
//email
@property (nonatomic,copy) NSString *email;

@end
