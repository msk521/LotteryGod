//
//  AnlyesSoftwarsViewController.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/6.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseViewController.h"
typedef void (^ReceivePreResult)(NSArray *haveSelected,NSDictionary *searchDic,NSArray *lookResult);
@interface AnlyesSoftwarsViewController : DZBaseViewController
@property (nonatomic,copy) ReceivePreResult receivePreResult;
/**
 *  已选分析数据
 */
@property (nonatomic,strong) NSArray *haveSelectedNumbers;
/**
 *  分析数据结果
 */
@property (nonatomic,strong) NSArray *haveAnlyesResult;
/**
 *  查询提交条件
 */
@property (nonatomic,strong) NSDictionary *searchDic;
@end
