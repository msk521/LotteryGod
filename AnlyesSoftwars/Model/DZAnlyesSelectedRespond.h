//
//  DZAnlyesSelectedRespond.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/22.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseModel.h"

@interface DZAnlyesSelectedRespond : DZBaseModel
//是否选中
@property (nonatomic,assign) BOOL selected;
//选中的数字名字
@property (nonatomic,copy) NSString *selectedName;
//提交的路径
@property (nonatomic,copy) NSString *commitParamter;
//提交用户选择的分析数据
@property (nonatomic,copy) NSString *commintValue;
//龙头凤尾时显示
@property (nonatomic,copy) NSString *ltfwValue;
//平衡指数时显示
@property (nonatomic,copy) NSString *phzsValue;
//连号轨迹
@property (nonatomic,copy) NSString *lhgjValue;
//胆码
@property (nonatomic,copy) NSString *danmaValue;
//为删除时做临时存储用
@property (nonatomic,copy) NSString *tempDanma;

@end
