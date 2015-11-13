//
//  DZPoidsQueryRequest.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/28.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZPoidsQueryRequest : DZBaseRequestModel
//彩种
@property (nonatomic,copy) NSString *lotteryId;
//期数
@property (nonatomic,copy) NSString *periods;

@end
