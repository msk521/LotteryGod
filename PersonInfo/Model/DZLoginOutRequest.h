//
//  DZLoginOutRequest.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/22.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZLoginOutRequest : DZBaseRequestModel
//账户
@property (nonatomic,copy) NSString *account;
//设备id
@property (nonatomic,copy) NSString *lastLoginUUID;
@end
