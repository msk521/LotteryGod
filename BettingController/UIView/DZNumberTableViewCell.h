//
//  DZNumberTableViewCell.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/8.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DZNumberTableViewCellDelegate;
@interface DZNumberTableViewCell : UITableViewCell{
  
    UIImageView             *_redBallImage;
    NSMutableArray          *selectNumberArray;
    id<DZNumberTableViewCellDelegate>  delegate;
}
@property (nonatomic, strong) NSMutableArray  *selectNumberArray;
@property (nonatomic, strong) id<DZNumberTableViewCellDelegate>  delegate;

//清空cell中选中的所有数据
- (void)refreshDataWith:(NSMutableArray *)slecteStr;
@end

@protocol DZNumberTableViewCellDelegate <NSObject>

//让当前tableview不能滑动
- (void)tableViewScrll:(BOOL)stop;

//每次选择数字时计算注数和钱
- (void)getTotalNotsAndMoney;

@end