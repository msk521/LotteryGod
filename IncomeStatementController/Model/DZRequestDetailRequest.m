//
//  DZRequestDetailRequest.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/24.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZRequestDetailRequest.h"

@implementation DZRequestDetailRequest
-(id)init{
    self = [super init];
    if (self) {
        self.pageCount = 20;
        self.pageIndex = 0;
    }
    return self;
}
@end
