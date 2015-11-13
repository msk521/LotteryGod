//
//  DZLoginViewController.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/3.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseViewController.h"
typedef void (^LogingSuccess) ();
typedef void (^LogingCancel) ();
@interface DZLoginViewController : DZBaseViewController
@property (nonatomic,copy) LogingSuccess loginSuccess;
@property (nonatomic,copy) LogingCancel loginCancel;
@property (nonatomic,strong) DZBaseViewController *fatherController;
@end
