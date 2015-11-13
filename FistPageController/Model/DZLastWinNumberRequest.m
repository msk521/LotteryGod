//
//  DZLastWinNumberRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/18.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZLastWinNumberRequest.h"

@implementation DZLastWinNumberRequest
-(id)init{
    self = [super init];
    if (self) {
        NSString *requestApi = [[[DZAllCommon shareInstance].currentLottyKind.lastNumbersUrl componentsSeparatedByString:BASEURL] lastObject];
        self.requestApi = requestApi;
    }
    return self;
}
@end
