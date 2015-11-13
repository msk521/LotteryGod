//
//  DZGenralQuery.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/28.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZGenralQuery.h"

@implementation DZGenralQuery
-(id)init{
    self = [super init];
    if (self) {
        self.requestApi = FixedRateLotteryChasePlanGenerator;
    }
    return self;
}
@end
