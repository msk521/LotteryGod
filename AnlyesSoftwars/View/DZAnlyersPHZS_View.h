//
//  DZAnlyersPHZS_View.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/10.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZAnylesView.h"
#import "DZAnlyesRespond.h"
@interface DZAnlyersPHZS_View : DZAnylesView
@property (nonatomic,copy) NSString *phzsNames;
-(void)replay:(DZAnlyesRespond *)model;
@end
