//
//  DZDanMaTableViewCell.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/8.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZAnlyesRespond.h"
typedef void (^SelectedNum)(NSMutableArray *danmas,NSMutableArray *danmaCount);

@interface DZDanMaTableViewCell : UITableViewCell
@property (nonatomic,copy) SelectedNum selectedNum;
-(void)replay:(DZAnlyesRespond *)model selectedNumbers:(NSMutableArray *)selectedNumbers danmacount:(NSMutableArray *)danmacount;
@end
