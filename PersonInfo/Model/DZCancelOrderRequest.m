//
//  DZCancelOrderRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/1.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZCancelOrderRequest.h"

@implementation DZCancelOrderRequest
-(id)init{
    self = [super init];
    if (self) {
        self.requestApi = [DZAllCommon shareInstance].allServiceRespond.lotteryOrderCancel;
    }
    return self;
}
@end
