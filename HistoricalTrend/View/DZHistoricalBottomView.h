//
//  DZHistoricalBottomView.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/2.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BtnSelected)(int,NSMutableArray *,int);
@interface DZHistoricalBottomView : UIView
@property (nonatomic,copy) BtnSelected btnSelected;
@end
