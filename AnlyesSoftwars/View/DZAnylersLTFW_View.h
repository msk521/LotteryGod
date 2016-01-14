//
//  DZAnylersLTFW_View.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/10.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZAnylesView.h"
#import "DZAnlyesRespond.h"
@interface DZAnylersLTFW_View : DZAnylesView
//选择的名字
@property (nonatomic,copy) NSString *selectedName;
-(void)replay:(DZAnlyesRespond *)model selectedNumber:(NSString *)selectedNumber;
@end

