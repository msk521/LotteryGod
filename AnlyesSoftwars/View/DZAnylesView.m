//
//  DZAnylesView.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/10.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZAnylesView.h"
#import "AppDelegate.h"
@implementation DZAnylesView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        AppDelegate *main = APPLICATION;
        self.frame = main.window.bounds;
        self.hidden = YES;
        self.alpha = 0.0f;
        [main.window addSubview:self];
        __weak DZAnylesView *domain = self;
        self.hiddenView = ^(){
            [UIView animateWithDuration:0.5f animations:^{
                CGAffineTransform ntransform = CGAffineTransformScale(domain.transform, 0.1, 0.1);
                domain.transform = ntransform;
                domain.alpha = 0.0;
                domain.center = main.window.center;
            } completion:^(BOOL finished) {
                domain.hidden = YES;
            }];
        };
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
    if (self.selectedDic) {
        if (self.selectedResult.length == 0) {
            return;
        }
        
        self.selectedDic(self.selectedAnlyesPath,self.selectedAnlyesName,self.selectedResult);
    }
}

-(void)shouldSelected{
    
}

@end
