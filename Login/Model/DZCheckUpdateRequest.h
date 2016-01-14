//
//  DZCheckUpdateRequest.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/21.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZCheckUpdateRequest : DZBaseRequestModel
/**
 *  版本号
 */
@property (nonatomic,copy) NSString *type;
@end
