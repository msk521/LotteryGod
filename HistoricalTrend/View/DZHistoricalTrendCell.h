//
//  DZHistoricalTrendCell.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/12.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZLastWinNumberRespond.h"
@interface DZHistoricalTrendCell : UITableViewCell
-(void)initLabels:(NSIndexPath *)indexPath winNum:(DZLastWinNumberRespond *)respond;
//求出平均出现次数
-(void)initLabelsWithAppears:(NSMutableDictionary *)dataSource;
//求最大遗漏数
-(void)initLabelsWithYL:(NSArray *)dataSource;
//求平均遗漏
-(void)initLabelsWithAdv:(NSArray *)dataSource;
//求最大连击
-(void)initLabelsWithBigLJ:(NSArray *)dataSource;
//当前剩余开奖时间
-(void)initLabelsWithLowShowWinNumber:(NSNumber *)dataSource;
@end
