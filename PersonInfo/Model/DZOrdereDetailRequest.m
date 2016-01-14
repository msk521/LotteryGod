//
//  VKOrdereDetailRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/23.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZOrdereDetailRequest.h"

@implementation DZOrdereDetailRequest
-(id)init{
    self = [super init];
    if (self) {
        self.requestApi = [DZAllCommon shareInstance].allServiceRespond.lotteryOrderDetails;
    }
    return self;
}
@end
