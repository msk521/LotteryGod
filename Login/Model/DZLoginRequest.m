//
//  DZLoginRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/21.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZLoginRequest.h"
#import <NSString+MKNetworkKitAdditions.h>

@implementation DZLoginRequest
-(id)init{
    self = [super init];
    if (self) {
        NSUserDefaults *defaulter = [NSUserDefaults standardUserDefaults];
        NSString *logiUUID = [defaulter objectForKey:@"loginUUID"];
        if (!logiUUID) {
            logiUUID = [NSString uniqueString];
            [defaulter setObject:logiUUID forKey:@"loginUUID"];
            [defaulter synchronize];
        }
        self.lastLoginUUID = logiUUID;
        self.requestApi = [DZAllCommon shareInstance].allServiceRespond.userLogin;
    }
    return self;
}
@end
