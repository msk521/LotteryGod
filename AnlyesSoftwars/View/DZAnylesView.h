//
//  DZAnylesView.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/10.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZBaseModel.h"
typedef void (^HiddenLTFWView)();
typedef void (^ShowLTFWView)(DZBaseModel *);
typedef void (^SelectedDic)(NSString *,NSString *, NSString*);
@interface DZAnylesView : UIView
@property (nonatomic,strong) NSString *selectedResult;
@property (nonatomic,strong) NSString *selectedAnlyesName;
@property (nonatomic,strong) NSString *selectedAnlyesPath;
@property (nonatomic,copy) HiddenLTFWView hiddenView;
@property (nonatomic,copy) ShowLTFWView showView;
//选择
@property (nonatomic,copy) SelectedDic selectedDic;
//隐藏view
- (IBAction)hiddenView:(UIButton *)sender;
//确认选择城市
- (IBAction)selectedShould:(UIButton *)sender;
-(void)shouldSelected;
@end
