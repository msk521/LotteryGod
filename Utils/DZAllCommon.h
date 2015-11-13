//
//  DZAllCommon.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/18.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZLottyKindsRespond.h"
#import "DZAllServiceRespond.h"
#import "DZUserInfoMation.h"
@interface DZAllCommon : NSObject
//当前彩种
@property (nonatomic,strong) DZLottyKindsRespond *currentLottyKind;
+(DZAllCommon*)shareInstance;
//存储请求地址
@property (nonatomic,strong) DZAllServiceRespond *allServiceRespond;
//用户信息
@property (nonatomic,strong) DZUserInfoMation *userInfoMation;
@end
