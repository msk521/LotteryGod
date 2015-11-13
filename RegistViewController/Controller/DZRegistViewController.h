//
//  DZRegistViewController.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/15.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseViewController.h"
typedef void (^HiddenView)(NSString *);
@interface DZRegistViewController : DZBaseViewController
@property (nonatomic,copy) HiddenView hiddenView;
@end
