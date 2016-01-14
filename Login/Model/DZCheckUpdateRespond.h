//
//  DZCheckUpdateRespond.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/21.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseModel.h"

@interface DZCheckUpdateRespond : DZBaseModel
/**
 *  版本号
 */
@property (nonatomic,copy) NSString *versionNumber;
/**
 *  是否强制升级
 */
@property (nonatomic,strong) NSNumber *forcedToUpgrade;
/**
 *  升级描述
 */
@property (nonatomic,copy) NSString *desc;
/**
 *  升级地址
 */
@property (nonatomic,copy) NSString *itmsServicesUrl;
@end
