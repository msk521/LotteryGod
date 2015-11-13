//
//  DZCancelOrderRequest.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/1.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZCancelOrderRequest : DZBaseRequestModel
//订单id
@property (nonatomic,copy) NSString *lotteryOrderId;
@end
