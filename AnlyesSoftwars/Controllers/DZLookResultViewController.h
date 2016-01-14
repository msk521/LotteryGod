//
//  DZLookResultViewController.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/23.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseViewController.h"

@interface DZLookResultViewController : DZBaseViewController
@property (nonatomic,strong) NSArray *searchResultArr;
//模式
@property (nonatomic,copy) NSString *parent;
/**
 *  分析条件
 */
@property (nonatomic,copy) NSString *anlyesStr;
@end
