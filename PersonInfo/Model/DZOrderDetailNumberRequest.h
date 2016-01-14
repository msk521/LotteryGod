//
//  DZOrderDetailNumberRequest.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/23.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZOrderDetailNumberRequest : DZBaseRequestModel
/**
 *  投注详情id
 */
@property (nonatomic,copy) NSString *detailId;
@end
