//
//  VKInterface.h
//  OldManChat
//
//  Created by 马士奎 on 15/10/3.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#ifndef OldManChat_VKInterface_h
#define OldManChat_VKInterface_h
#define BASEURL @""
//彩种
#define ServiceURL @"http://182.92.174.9:8080/lgms/metainfo.json"
//付款
#define PAYMONEYURL @"http://182.92.174.9:8080/lgms/pingpp/reqcharge.shtml"
//高级追号－（固定倍率）
#define FixedRateLotteryChasePlanGenerator [NSString stringWithFormat:@"%@?generatorName=fixedRateLotteryChasePlanGenerator",[DZAllCommon shareInstance].allServiceRespond.chasePlanGenerate]
//高级追号－（最小盈利）
#define LowestYieldLotteryChasePlanGenerator [NSString stringWithFormat:@"%@?generatorName=lowestYieldLotteryChasePlanGenerator",[DZAllCommon shareInstance].allServiceRespond.chasePlanGenerate]
#endif
