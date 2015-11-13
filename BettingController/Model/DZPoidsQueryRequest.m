//
//  DZPoidsQueryRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/28.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZPoidsQueryRequest.h"

@implementation DZPoidsQueryRequest
-(id)init{
    self = [super init];
    if (self) {
        self.requestApi = [DZAllCommon shareInstance].allServiceRespond.lotteryInfo;
    }
    return self;
}
@end
