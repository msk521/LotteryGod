//
//  DZBettingView.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/8.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DZNumberTableViewCell.h"
typedef void (^SelectedNumbs) (NSInteger,NSInteger,NSMutableArray*);
@interface DZBettingView : UIView<DZNumberTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>

{
    UIButton            *_shakeButton;          //摇一摇按钮
    
    UITableView         *_PLFiveTableView;      //直选tableview
    
    UIView              *_toolbarView;          //底部清空和确定按钮
    UILabel             *_numberNots;           //共几注
    UILabel             *_totalMoney;           //共多少钱
    
    NSInteger           totalNumberNots;        //所有注数
    BOOL                _open_lotteryView;      //是否打开中奖详情
    
    NSMutableArray      *_shakeNumber;          //摇一摇机选数
    NSMutableArray      *_makeSureSelectNumArray;//确定选好的号码

    
    BOOL                isRefresh;
}
@property (nonatomic,copy) SelectedNumbs selectedNumbs;
@property (nonatomic,assign) BOOL                _refreshData;           //是否刷新数据
//晃动结束
- (void)motionEnded;
//检测到摇动
- (void)motionBeganing;
//清空
-(void)cleanAllSelected;
//任选多少位
-(void)selectedAnyNumbersWith:(int)num;
@end
