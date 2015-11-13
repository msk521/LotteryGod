//
//  DZLottySearchRequet.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/18.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZLottySearchRequet.h"

@implementation DZLottySearchRequet
-(id)init{
    self = [super init];
    if (self) {
        self.pageCount = 20;
        self.pageIndex = 1;
        NSString *requestApi = [[[DZAllCommon shareInstance].currentLottyKind.allNumbersUrl componentsSeparatedByString:BASEURL] lastObject];
        self.requestApi = requestApi;
    }
    return self;
}
@end
