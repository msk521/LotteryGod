//
//  DZUpdateUserInfoRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/5.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZUpdateUserInfoRequest.h"

@implementation DZUpdateUserInfoRequest
-(id)init{
    self = [super init];
    if (self) {
        self.requestApi = [DZAllCommon shareInstance].allServiceRespond.userUpdate;
    }
    return self;
}
@end
