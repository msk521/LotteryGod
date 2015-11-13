//
//  DZGetMoneyRecordRequest.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/11.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZGetMoneyRecordRequest : DZBaseRequestModel
//每页显示多少
@property (nonatomic,assign) int pageCount;
//第几页
@property (nonatomic,assign) int pageIndex;
//用户
@property (nonatomic,copy) NSString *account;
@end
