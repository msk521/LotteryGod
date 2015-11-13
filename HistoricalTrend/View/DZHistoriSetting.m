//
//  DZHistoriSetting.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/12.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZHistoriSetting.h"
#import "AppDelegate.h"

@implementation DZHistoriSetting

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {

        
    }
    return self;
}

//隐藏view
- (IBAction)hiddenView:(UIButton *)sender {
    if (self.hiddenView) {
        self.hiddenView();
    }
}

//确认选择
- (IBAction)selectedShould:(UIButton *)sender {
    if (self.hiddenView) {
        self.hiddenView();
    }
    [self shouldSelected];
}

-(void)shouldSelected{
    
}


@end
