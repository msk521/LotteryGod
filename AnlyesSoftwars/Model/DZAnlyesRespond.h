//
//  DZAnlyesRespond.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/20.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseModel.h"

@interface DZAnlyesRespond : DZBaseModel
//提交时的参数字段
@property (nonatomic,copy) NSString *flag;
//分析名称
@property (nonatomic,copy) NSString *name;
//分析名称2
@property (nonatomic,copy) NSString *desc;
//
@property (nonatomic,copy) NSString *jsonPath;
//需要显示的数据
@property (nonatomic,strong) NSDictionary *possibleValues;

@end
