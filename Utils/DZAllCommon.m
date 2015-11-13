//
//  DZAllCommon.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/18.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZAllCommon.h"

@implementation DZAllCommon

+(DZAllCommon*)shareInstance{
    //利用gcd创建一个单例模式
    static DZAllCommon *allCommon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //创建当前单例
        allCommon = [[DZAllCommon alloc]init];
    });
    return allCommon;
}

-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
