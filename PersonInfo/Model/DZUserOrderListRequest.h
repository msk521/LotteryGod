//
//  DZUserOrderListRequest.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/1.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZUserOrderListRequest : DZBaseRequestModel
//账户
@property (nonatomic,copy) NSString *account;
//每页显示多少
@property (nonatomic,assign) int pageCount;
//第几页
@property (nonatomic,assign) int pageIndex;
@end
