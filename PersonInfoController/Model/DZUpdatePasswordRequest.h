//
//  DZUpdatePasswordRequest.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/9.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZUpdatePasswordRequest : DZBaseRequestModel
//用户名
@property (nonatomic,copy) NSString *account;
//原密码
@property (nonatomic,copy) NSString *password;
//新密码
@property (nonatomic,copy) NSString *password1;
//确认密码
@property (nonatomic,copy) NSString *password2;
@end
