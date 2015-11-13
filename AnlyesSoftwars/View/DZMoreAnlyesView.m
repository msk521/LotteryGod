//
//  DZMoreAnlyesView.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/14.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZMoreAnlyesView.h"

@implementation DZMoreAnlyesView

- (IBAction)hiddenView:(id)sender {
    if (self.hiddenView) {
        self.hiddenView();
    }
}

//选择分析类型
- (IBAction)selectedAnlyesType:(UIButton *)sender {

    if (self.selectedAnlyes) {
        self.selectedAnlyes(sender);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
