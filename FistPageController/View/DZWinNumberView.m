//
//  DZWinNumberView.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/26.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZWinNumberView.h"
#import "MZTimerLabel.h"
#import "DZLastWinNumberRequest.h"
#import "DZLastWinNumberRespond.h"
#import "DZRequest.h"
#import "DZUserBalaceRequest.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "DZBaseViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ZCSlotMachine.h"
@interface DZWinNumberView()<MZTimerLabelDelegate,ZCSlotMachineDelegate, ZCSlotMachineDataSource>{
     ZCSlotMachine *_slotMachine;
    UIView *_slotContainerView;
    NSArray *_slotIcons;
    
    __weak IBOutlet UIImageView *ball1;
    //第二个中奖小球
    __weak IBOutlet UIImageView *ball2;
    //第三个中奖小球
    __weak IBOutlet UIImageView *ball3;
    //第四个中奖小球
    __weak IBOutlet UIImageView *ball4;
    //第五个中奖小球
    __weak IBOutlet UIImageView *ball5;
    //下次开奖剩余时间
    __weak IBOutlet UILabel *nextTime;
    //银币
    __weak IBOutlet UILabel *userRange;
    //金币
    __weak IBOutlet UILabel *mybalance;
    MZTimerLabel *timerExample3;
    NSString *nWinNum ;
    DZLastWinNumberRespond *currentFP;
    //循环次数
    int cycleNum;
    MBProgressHUD *hud;
    //当前多少期
    __weak IBOutlet UILabel *currentPoidsLabel;
    AppDelegate *delegate;
    NSDateFormatter *dateFormatter;
    DZBaseViewController *currentViewController;
     SystemSoundID soundID;
    __weak IBOutlet UIView *topView;
    __weak IBOutlet UIView *bootmView;
}

@end

@implementation DZWinNumberView
-(void)replay:(DZLastWinNumberRespond *)fpTop{
    if (!_slotIcons) {
        _slotIcons = [NSArray arrayWithObjects:
                  [UIImage imageNamed:@"ballx1"], [UIImage imageNamed:@"ballx2"], [UIImage imageNamed:@"ballx3"], [UIImage imageNamed:@"ballx4"],[UIImage imageNamed:@"ballx5"], [UIImage imageNamed:@"ballx6"], [UIImage imageNamed:@"ballx7"], [UIImage imageNamed:@"ballx8"], [UIImage imageNamed:@"ballx9"],[UIImage imageNamed:@"ballx10"],[UIImage imageNamed:@"ballx11"], nil];
         }
    if (!_slotMachine) {
        _slotMachine = [[ZCSlotMachine alloc] initWithFrame:CGRectMake(0, 0, 291, 170)];
        _slotMachine.center = CGPointMake(self.frame.size.width / 2, 60);
        _slotMachine.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _slotMachine.contentInset = UIEdgeInsetsMake(5, 8, 5, 8);
        _slotMachine.delegate = self;
        _slotMachine.dataSource = self;
        [self setClipsToBounds:YES];
         [self addSubview:_slotMachine];
    }
    if (!_slotContainerView) {
        _slotContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 40)];
        _slotContainerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _slotContainerView.center = CGPointMake(self.frame.size.width / 2, 350);
        [self addSubview:_slotContainerView];
    }
    
    delegate = [UIApplication sharedApplication].delegate;
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.superview];
        hud.labelText = @"开奖中...";
//        [self.superview addSubview:hud];
    }
    [hud hide:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UserBlance object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetUserBalance) name:UserBlance object:nil];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:dd"];
    
    currentFP = fpTop;
    delegate.currentRespond = fpTop;
    currentPoidsLabel.text = [NSString stringWithFormat:@"第%@期",currentFP.period];
    NSArray *winNumbers = [fpTop.numbers componentsSeparatedByString:@","];
    for (int i = 0; i < winNumbers.count; i++) {
        UIImageView *imgView = (UIImageView*)[self viewWithTag:100 + i];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[winNumbers[i] intValue]]];
    }
    _slotMachine.slotResults = [NSArray arrayWithObjects:
                                [NSNumber numberWithInteger:[winNumbers[0] intValue]],
                                [NSNumber numberWithInteger:[winNumbers[1] intValue]],
                                [NSNumber numberWithInteger:[winNumbers[2] intValue]],
                                [NSNumber numberWithInteger:[winNumbers[3] intValue]],[NSNumber numberWithInteger:[winNumbers[4] intValue]],
                                nil];
    _slotMachine.singleUnitDuration = -1;
    [self startWith:fpTop];
    [self resetUserBalance];
    if (![DZUtile checkTime]) {
       
        NSInteger minus = [DZUtile requestTimeMinusWith:currentFP.receiveTime];
        [self resetTimer:minus];
    }else{
        if (timerExample3) {
            [timerExample3 setCountDownTime:0];
        }
    }
    [self bringSubviewToFront:_slotMachine];
    [self bringSubviewToFront:topView];
    [self bringSubviewToFront:bootmView];
}

-(void)resetTimer:(NSInteger)minus{
    if (!timerExample3) {
        timerExample3 = [[MZTimerLabel alloc] initWithLabel:nextTime andTimerType:MZTimerLabelTypeTimer];
        timerExample3.delegate = self;
        timerExample3.resetTimerAfterFinish = NO;
        timerExample3.timeFormat = @"mm:ss";
    }
    NSInteger intervalTime = [DZAllCommon shareInstance].currentLottyKind.intervalTime.intValue;
    NSInteger  minusTime = intervalTime - minus;
    if (minusTime < 0) {
        minusTime = 0;
    }
    if (minusTime > intervalTime) {
        minusTime = intervalTime;
    }
//    if (!timerExample3.counting) {
        [timerExample3 setCountDownTime:minusTime];
        [timerExample3 reset];
        [timerExample3 start];
//    }
    NSLog(@"minusTime:%d",(int)minusTime);
}

#pragma mark---MZTimerLabelDelegate

-(void)timerLabel:(MZTimerLabel*)timerLabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType;
{
    delegate.currentTime = timerLabel.timeLabel.text;
    if (self.currentTime) {
        self.currentTime(timerLabel);
    }
}

-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    //刷新当前开奖情况
    cycleNum = 0;
    [self requestLastNumber:timerLabel];
}

-(void)requestLastNumber:(MZTimerLabel*)timerLabel {
    DZLastWinNumberRequest *lastRequest = [[DZLastWinNumberRequest alloc] init];
    if ([DZUtile checkTime]) {
        cycleNum = -1;
    }
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (cycleNum != -1) {
            [[DZRequest shareInstance] requestWithParamter:lastRequest requestFinish:^(NSDictionary *result) {
                NSDictionary *dic = result[@"result"];
                if (dic) {
                    AppDelegate *delegae = [UIApplication sharedApplication].delegate;
                    delegae.shouldAgainRequestWinNumber = NO;
                    DZLastWinNumberRespond *respond = [[DZLastWinNumberRespond alloc] initWithDic:dic];
                    if (![respond.period isEqualToString:currentFP.period]) {
                        cycleNum = -1;
                        currentFP = respond;
                        NSUserDefaults *defaulters = [NSUserDefaults standardUserDefaults];
                        if (![defaulters objectForKey:@"closeMusic"] || [[defaulters objectForKey:@"closeMusic"] intValue] == 1) {
                            NSString *path = [[NSBundle mainBundle] pathForResource:@"winNum2" ofType:@"wav"];
                            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
                            AudioServicesPlaySystemSound(soundID);
                        }
                        _slotMachine.singleUnitDuration = 0.14f;
                        [self startWith:currentFP];
                        currentPoidsLabel.text = [NSString stringWithFormat:@"第%@期",currentFP.period];
                        if (self.currentPoids) {
                            self.currentPoids(currentFP.period);
                        }
                        delegate.currentRespond = respond;
                        [self requestUserBalance];
                        [hud hide:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"restarTime" object:nil];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RestTimerNotification" object:nil];
                        
        }else{
            NSAssert(timerLabel != nil, @"倒计时出错");
                cycleNum = 0;
                [self requestLastNumber:timerLabel];
            }
        }
            }requestFaile:^(NSString *result) {
                
            }];
        }
    });
}


//获取用户金币数
-(void)requestUserBalance{
    [hud hide:YES];
    if (![DZAllCommon shareInstance].userInfoMation.account || [DZAllCommon shareInstance].userInfoMation.account.length == 0) {
        return;
    }
    [hud hide:YES];
    DZUserBalaceRequest *request = [[DZUserBalaceRequest alloc] init];
    [[DZRequest shareInstance] requestWithParamter:request requestFinish:^(NSDictionary *result) {
        
        if (result[@"result"] && [result[@"success"] intValue] != 0) {
            NSDictionary *resultDic = result[@"result"];
            DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
            userInfoMation.balance = resultDic[@"balance"];
            userInfoMation.score = resultDic[@"score"];
            [DZUtile saveData];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserBlance object:nil];
        }
    } requestFaile:^(NSString *result) {
        
    }];
}

//设置用户余额信息
-(void)resetBalance{
    [hud hide:YES];
    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
    if (userInfoMation.balance && userInfoMation.score) {
//        NSString *balanceStr = [NSString stringWithFormat:@"%@点",userInfoMation.balance];
//        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:balanceStr];
//        UIColor *color = [UIColor blackColor];
//        
//        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                       color,NSForegroundColorAttributeName,nil];
//        [attributedStr addAttributes:attributeDict range:NSMakeRange(balanceStr.length-1,1)];
//        mybalance.attributedText = attributedStr;
        mybalance.text = userInfoMation.balance;
        userRange.text = userInfoMation.score;
    }
}

-(void)resetUserBalance{
    [hud hide:YES];
    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
    
    if (userInfoMation.balance && userInfoMation.score) {
        NSString *balanceStr = [NSString stringWithFormat:@"%@点",userInfoMation.balance];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:balanceStr];
        UIColor *color = [UIColor blackColor];
        
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       color,NSForegroundColorAttributeName,nil];
        [attributedStr addAttributes:attributeDict range:NSMakeRange(balanceStr.length-1,1)];
        mybalance.attributedText = attributedStr;
        userRange.text = userInfoMation.score;
    }else{
        mybalance.text = @"";
        userRange.text = @"";
    }
}

- (void)startWith:(DZLastWinNumberRespond *)winNum{
    NSArray *nNumbers = [winNum.numbers componentsSeparatedByString:@","];
    NSUInteger slotOneIndex = [nNumbers[0] intValue]-1;
    NSUInteger slotTwoIndex = [nNumbers[1] intValue]-1;
    NSUInteger slotThreeIndex = [nNumbers[2] intValue]-1;
    NSUInteger slotFourIndex = [nNumbers[3] intValue]-1;
    NSUInteger slotFiveIndex = [nNumbers[4] intValue]-1;
    _slotMachine.slotResults = [NSArray arrayWithObjects:
                                [NSNumber numberWithInteger:slotOneIndex],
                                [NSNumber numberWithInteger:slotTwoIndex],
                                [NSNumber numberWithInteger:slotThreeIndex],
                                [NSNumber numberWithInteger:slotFourIndex],[NSNumber numberWithInteger:slotFiveIndex],
                                nil];
    
    [_slotMachine startSliding];
}
#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [self startWith:currentFP];
}

#pragma mark - ZCSlotMachineDelegate

- (void)slotMachineWillStartSliding:(ZCSlotMachine *)slotMachine {
  
}

- (void)slotMachineDidEndSliding:(ZCSlotMachine *)slotMachine {
    if (slotMachine.singleUnitDuration == -1 || slotMachine.singleUnitDuration == 0) {
        return;
    }
    NSInteger intervalTime = [DZAllCommon shareInstance].currentLottyKind.intervalTime.intValue;
    NSInteger minus = [DZUtile requestTimeMinusWith:currentFP.receiveTime];
    [timerExample3 setCountDownTime:intervalTime -minus];
    [timerExample3 start];
}

#pragma mark - ZCSlotMachineDataSource

- (NSArray *)iconsForSlotsInSlotMachine:(ZCSlotMachine *)slotMachine {
    return _slotIcons;
}

- (NSUInteger)numberOfSlotsInSlotMachine:(ZCSlotMachine *)slotMachine {
    return 5;
}

- (CGFloat)slotWidthInSlotMachine:(ZCSlotMachine *)slotMachine {
    return 50.0f;
}

- (CGFloat)slotSpacingInSlotMachine:(ZCSlotMachine *)slotMachine {
    return 5.0f;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
