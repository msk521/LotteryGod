//
//  DZCheckUpdateRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/21.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZCheckUpdateRequest.h"

@implementation DZCheckUpdateRequest
-(id)init{
    self = [super init];
    if (self) {
        self.type = @"ios";
        self.requestApi = [DZAllCommon shareInstance].allServiceRespond.lastClientVersion;
    }
    return self;
}
@end
