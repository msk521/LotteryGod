//
//  DZInvitationGoodRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/11.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZInvitationGoodRequest.h"

@implementation DZInvitationGoodRequest
-(id)init{
    self = [super init];
    if (self) {
        self.requestApi = [DZAllCommon shareInstance].allServiceRespond.qrcode;
        self.account = [DZAllCommon shareInstance].userInfoMation.account;
    }
    return self;
}
@end
