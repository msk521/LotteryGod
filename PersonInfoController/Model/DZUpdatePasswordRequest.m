//
//  DZUpdatePasswordRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/9.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZUpdatePasswordRequest.h"

@implementation DZUpdatePasswordRequest
-(id)init{
    self = [super init];
    if (self) {
        self.requestApi = [DZAllCommon shareInstance].allServiceRespond.userUpdate;
        self.account = [DZAllCommon shareInstance].userInfoMation.account;
    }
    return self;
}
@end
