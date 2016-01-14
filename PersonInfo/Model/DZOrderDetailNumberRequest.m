//
//  DZOrderDetailNumberRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/23.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZOrderDetailNumberRequest.h"

@implementation DZOrderDetailNumberRequest
-(id)init{
    self = [super init];
    if (self) {
        self.requestApi = [DZAllCommon shareInstance].allServiceRespond.lotteryOrderDetailNumbers;
    }
    return self;
}
@end
