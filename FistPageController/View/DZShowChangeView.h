//
//  DZShowChangeView.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/6.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZLottyKindsRespond.h"
#import "DZLastWinNumberRespond.h"
#import "DZBaseModel.h"
typedef void (^HiddenView)();
typedef void (^ShowView)(DZLottyKindsRespond *);
typedef void (^ChangeLottyKind)(DZLastWinNumberRespond *);
@interface DZShowChangeView : UIView
@property (weak, nonatomic) IBOutlet UITableView *tableview;
//隐藏当前view
@property (nonatomic,copy) HiddenView hiddenView;
//选择某一项之后隐藏
@property (nonatomic,copy) ShowView showView;
//切换城市
@property (nonatomic,copy) ChangeLottyKind changeLottyKind;
//查询所有彩种
-(void)requestCitys;

@end
