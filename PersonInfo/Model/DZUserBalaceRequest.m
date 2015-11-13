//
//  DZUserBalaceRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/31.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZUserBalaceRequest.h"

@implementation DZUserBalaceRequest
-(id)init{
    self = [super init];
    if (self) {
        self.requestApi = [DZAllCommon shareInstance].allServiceRespond.userInfo;
        self.account = [DZAllCommon shareInstance].userInfoMation.account;
    }
    return self;
}
@end
