//
//  DZMoreAnlyesView.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/14.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^HiddenMoreView)();
typedef void (^SelectedAnlyes)(UIButton*);
@interface DZMoreAnlyesView : UIView
@property (nonatomic,copy) SelectedAnlyes selectedAnlyes;
@property (nonatomic,copy) HiddenMoreView hiddenView;
@end
