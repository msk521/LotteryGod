//
//  DZWinNumberView.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/26.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZLastWinNumberRespond.h"
#import "MZTimerLabel.h"
typedef void (^CurrentPoids)(NSString *);
typedef void (^CurrentTimes)(MZTimerLabel *);
@interface DZWinNumberView : UIView
@property (nonatomic,copy) CurrentTimes  currentTime;
@property (nonatomic,copy) CurrentPoids currentPoids;
-(void)replay:(DZLastWinNumberRespond *)fpTop;
@end
