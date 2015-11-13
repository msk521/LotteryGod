//
//  DZAnlyesOtherView.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/22.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZAnylesView.h"
#import "DZAnlyesRespond.h"
@interface DZAnlyesOtherView : DZAnylesView
-(void)replay:(DZAnlyesRespond *)model;
//胆码
-(void)replayDM:(DZAnlyesRespond *)model;
//和值
-(void)replayHZ:(DZAnlyesRespond *)model;
@end
