//
//  DZLoginRequest.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/21.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZLoginRequest : DZBaseRequestModel
//用户名
@property (nonatomic,copy) NSString *account;
//密码
@property (nonatomic,copy) NSString *password;
//设备id
@property (nonatomic,copy) NSString *lastLoginUUID;
@end
