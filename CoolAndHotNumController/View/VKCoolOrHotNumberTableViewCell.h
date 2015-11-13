//
//  VKCoolOrHotNumberTableViewCell.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/13.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKCoolOrHotNumberTableViewCell : UITableViewCell
//每个号码共出现多少次
-(void)replay:(NSDictionary *)percents totalNum:(int)totlaNum;
@end
