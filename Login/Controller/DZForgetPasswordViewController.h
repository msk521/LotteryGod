//
//  DZForgetPasswordViewController.h
//  LotteryGod
//
//  Created by 马士奎 on 15/12/3.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseViewController.h"
typedef void (^HiddenViewFG)(NSString *);
@interface DZForgetPasswordViewController : DZBaseViewController
@property (nonatomic,copy) HiddenViewFG hiddenView;

@end
