//
//  DZUserOrderListRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/1.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZUserOrderListRequest.h"

@implementation DZUserOrderListRequest
-(id)init{
    self = [super init];
    if (self) {
        self.requestApi = [DZAllCommon shareInstance].allServiceRespond.lotteryOrderList;
        self.account = [DZAllCommon shareInstance].userInfoMation.account;
        self.pageIndex = 0;
        self.pageCount = 20;
    }
    return self;
}
@end
