//
//  DZFPTopTableViewCell.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/5.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"
#import "DZLastWinNumberRespond.h"
#import "DZFPTop.h"
typedef void (^CurrentTime)(MZTimerLabel *);
@interface DZFPTopTableViewCell : UITableViewCell
@property (nonatomic,copy) CurrentTime  currentTime;
-(void)replay:(DZLastWinNumberRespond *)fpTop;
@end
