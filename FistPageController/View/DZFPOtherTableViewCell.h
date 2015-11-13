//
//  DZFPOtherTableViewCell.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/5.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^JumpToController)(int);
@interface DZFPOtherTableViewCell : UITableViewCell
@property (nonatomic,copy) JumpToController jumpToController;
@end
