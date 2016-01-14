//
//  DZLoginOutRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/22.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZLoginOutRequest.h"

@implementation DZLoginOutRequest
-(id)init{
    self = [super init];
    if (self) {
        NSUserDefaults *defaulter = [NSUserDefaults standardUserDefaults];
        NSString *logiUUID = [defaulter objectForKey:@"loginUUID"];
        self.lastLoginUUID = logiUUID;
        self.account = [DZAllCommon shareInstance].userInfoMation.account;
        self.requestApi = [DZAllCommon shareInstance].allServiceRespond.userLogout;
    }
    return self;
}
@end
