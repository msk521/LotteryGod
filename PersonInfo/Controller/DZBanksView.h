//
//  DZBanksView.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/10.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectedBank)(NSString *name);
@interface DZBanksView : UIView
@property (nonatomic,copy) SelectedBank selectedBank;
-(void)replay:(NSArray *)banks;
@end
