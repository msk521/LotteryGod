//
//  DZGetMoneyRecordRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/11.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZGetMoneyRecordRequest.h"

@implementation DZGetMoneyRecordRequest
-(id)init{
    self = [super init];
    if (self) {
        self.requestApi = [DZAllCommon shareInstance].allServiceRespond.userWithdrawalsApply;
        self.pageCount = 20;
        self.pageIndex = 0;
        self.account = [DZAllCommon shareInstance].userInfoMation.account;
    }
    return self;
}
@end
