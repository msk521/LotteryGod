//
//  DZLottyKindsRespond.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/18.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseModel.h"

@interface DZLottyKindsRespond : DZBaseModel
//所有中奖号码地址
@property (nonatomic,copy) NSString *allNumbersUrl;
//彩票代码
@property (nonatomic,copy) NSString *code;
//第一次开奖时间
@property (nonatomic,copy) NSString *firstTime;
//id
@property (nonatomic,copy) NSString *id;
//开奖时间间隔
@property (nonatomic,copy) NSString *intervalTime;
//最后开奖时间
@property (nonatomic,copy) NSString *lastTime;
//最后一次开奖地址
@property (nonatomic,copy) NSString *lastNumbersUrl;
//彩种名称
@property (nonatomic,copy) NSString *name;
//组
@property (nonatomic,copy) NSString *group;
//分析请求地址
@property (nonatomic,copy) NSString *judge;
//获取分析项
@property (nonatomic,copy) NSString *judgers;
//备注
@property (nonatomic,copy) NSString *remarks;
//服务器获取开奖时间
@property (nonatomic,copy) NSString *receiveTime;
//玩法
@property (nonatomic,strong) NSArray *plays;

@end
