//
//  DZHistoriSetting.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/12.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZBaseModel.h"
typedef void (^HiddenHistoryView)();
typedef void (^ShowHistoryView)(DZBaseModel *);
@interface DZHistoriSetting : UIView
@property (nonatomic,copy) HiddenHistoryView hiddenView;
@property (nonatomic,copy) ShowHistoryView showView;
@end
