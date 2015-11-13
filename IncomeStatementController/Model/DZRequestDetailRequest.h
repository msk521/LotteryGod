//
//  DZRequestDetailRequest.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/24.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZRequestDetailRequest : DZBaseRequestModel
@property (nonatomic,copy) NSString *account;
@property (nonatomic,assign) int pageCount;
@property (nonatomic,assign) int pageIndex;
//balance金币 银币score
@property (nonatomic,copy) NSString *type;
@end
