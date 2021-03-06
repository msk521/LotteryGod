//
//  DZFPTopTableViewCell.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/5.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZFPTopTableViewCell.h"
#import "DZLastWinNumberRequest.h"
#import "DZLastWinNumberRespond.h"
#import "DZRequest.h"
#import "DZUserBalaceRequest.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
@interface DZFPTopTableViewCell()<MZTimerLabelDelegate>{
    //第一个中奖小球
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
    //模拟币图标
    __weak IBOutlet UIImageView *moneyIcon;
    //模拟币
    UILabel *moneyLabel;
    //模拟币单位点
    UILabel *moneyUtil;
    //模拟币名称
    __weak IBOutlet UILabel *moneyName;
    NSDateFormatter *dateFormatter;
    __weak IBOutlet UILabel *userRange;
    MZTimerLabel *timerExample3;
    NSString *nWinNum ;
    DZLastWinNumberRespond *currentFP;
    //循环次数
    int cycleNum;
    MBProgressHUD *hud;
    //当前多少期
    __weak IBOutlet UILabel *currentPoidsLabel;
    AppDelegate *delegate;
}
@end
@implementation DZFPTopTableViewCell

- (void)awakeFromNib {
    delegate = [UIApplication sharedApplication].delegate;
    hud = [[MBProgressHUD alloc] initWithView:self.contentView];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"开奖中...";
    [self.contentView addSubview:hud];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetUserBalance) name:UserBlance object:nil];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:dd"];
    
    nextTime.layer.cornerRadius = 5.0f;
    nextTime.layer.masksToBounds = YES;
    moneyLabel = [[UILabel alloc] init];
    moneyLabel.frame = CGRectMake(moneyName.frame.origin.x+ moneyName.frame.size.width + 10, moneyName.frame.origin.y, 80, 21);
    moneyLabel.textColor = COLOR(196, 0, 19);
    moneyLabel.font = [UIFont systemFontOfSize:13.0f];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:moneyLabel];
    moneyUtil = [[UILabel alloc] init];
    moneyUtil.textAlignment = NSTextAlignmentCenter;
    moneyUtil.frame = CGRectMake(moneyLabel.frame.origin.x+moneyLabel.frame.size.width , moneyLabel.frame.origin.y, 20, 21);
    moneyUtil.font = [UIFont boldSystemFontOfSize:13.0f];
    moneyUtil.hidden = YES;
    moneyUtil.text = @"点";
    [self.contentView addSubview:moneyUtil];
}

-(void)resetTimer:(NSInteger)minus{
    if (!timerExample3) {
        timerExample3 = [[MZTimerLabel alloc] initWithLabel:nextTime andTimerType:MZTimerLabelTypeTimer];
        timerExample3.delegate = self;
        timerExample3.resetTimerAfterFinish = YES;
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
    [timerExample3 setCountDownTime:minusTime];
    [timerExample3 start];
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
    [self requestLastNumber:timerLabel];
}

-(void)requestLastNumber:(MZTimerLabel*)timerLabel {
    DZLastWinNumberRequest *lastRequest = [[DZLastWinNumberRequest alloc] init];
    NSInteger intervalTime = [DZAllCommon shareInstance].currentLottyKind.intervalTime.intValue;

    [hud show:YES];
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
                        currentFP = respond;
                        [self resetWinNumbers:respond];
                        NSInteger minus = [DZUtile requestTimeMinusWith:currentFP.receiveTime];
                        [timerExample3 setCountDownTime:intervalTime -minus];
                        [timerLabel start];
                        cycleNum = -1;
                        currentPoidsLabel.text = [NSString stringWithFormat:@"第%@期",currentFP.period];
                         delegate.currentRespond = respond;
                        [self requestUserBalance];
                        [hud hide:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"restarTime" object:nil];
                    }else{
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
    if (![DZAllCommon shareInstance].userInfoMation.account || [DZAllCommon shareInstance].userInfoMation.account.length == 0) {
        return;
    }
    
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

//重新刷新中奖号码
-(void)resetWinNumbers:(DZLastWinNumberRespond *)winNum{
    NSArray *winNumbers = [winNum.numbers componentsSeparatedByString:@","];
    nWinNum = winNum.numbers;
    NSArray *oldNumbers = [currentFP.numbers componentsSeparatedByString:@","];
    for (int i = 0; i < 5; i++) {
        int winNum = [oldNumbers[i] intValue];
        int nWinNumValue = [winNumbers[i] intValue];
        NSArray *nextNumbers = [self changeToNextWinNum:winNum nWinNums:nWinNumValue];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (i == 0) {
                [self showAnimationWithImageView:ball1 nextNumbers:nextNumbers];
            }else if (i == 1){
                [self showAnimationWithImageView:ball2 nextNumbers:nextNumbers];
            }else if (i == 2){
                [self showAnimationWithImageView:ball3 nextNumbers:nextNumbers];
            }else if (i == 3){
                [self showAnimationWithImageView:ball4 nextNumbers:nextNumbers];
            }else if (i == 4){
                [self showAnimationWithImageView:ball5 nextNumbers:nextNumbers];
            }
        });
    }
     currentFP = winNum;
}

-(void)showAnimationWithImageView:(UIImageView *)imageView nextNumbers:(NSArray *)nextNumbers{
    NSArray *winNumbers = [nWinNum componentsSeparatedByString:@","];
    int index = (int)imageView.tag - 100;
    NSString *imageName = [NSString stringWithFormat:@"ball%d",[winNumbers[index] intValue]];
    [imageView setImage:[UIImage imageNamed:imageName]];

    [imageView setAnimationImages:nextNumbers];
    
    imageView.animationDuration = 1.0;
    // repeat the annimation forever
    imageView.animationRepeatCount = 1;
    // start animating
    [imageView startAnimating];
}

-(void)replay:(DZLastWinNumberRespond *)fpTop{
    currentFP = fpTop;
    delegate.currentRespond = fpTop;
    currentPoidsLabel.text = [NSString stringWithFormat:@"第%@期",currentFP.period];
    NSArray *winNumbers = [fpTop.numbers componentsSeparatedByString:@","];
    for (int i = 0; i < winNumbers.count; i++) {
        UIImageView *imgView = (UIImageView*)[self viewWithTag:100 + i];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[winNumbers[i] intValue]]];
    }
    
    if (![DZUtile checkTime]) {
        [hud setHidden:YES];
        NSInteger minus = [DZUtile requestTimeMinusWith:currentFP.receiveTime];
        [self resetTimer:minus];
        [self resetUserBalance];
    }
}


//设置用户余额信息
-(void)resetBalance{
    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
    if (userInfoMation.balance && userInfoMation.score) {
        moneyLabel.text = userInfoMation.balance;
        userRange.text = userInfoMation.score;
    }
}
-(void)resetUserBalance{

    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
    
    if (userInfoMation.balance && userInfoMation.score) {
        moneyLabel.text = userInfoMation.balance;
        userRange.text = userInfoMation.score;
        
        NSDictionary *attribute = @{NSFontAttributeName:moneyLabel.font};
        CGSize retSize = [userInfoMation.balance boundingRectWithSize:CGSizeMake(0, 10000)
                                                              options:
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                                           attributes:attribute
                                                              context:nil].size;
        CGRect nameLabelRect = moneyLabel.frame;
        nameLabelRect.size.width = retSize.width;
        
        CGFloat orginx = nameLabelRect.origin.x + nameLabelRect.size.width + 5;
        if (orginx + moneyUtil.frame.size.width <= userRange.frame.origin.x - 62) {
            float add = 0.0f;
            if (iPhone6) {
                add = 250 - 212;
            }
            if (iPhone6Plus) {
                add = 280 - 212;
                
            }
            if (moneyUtil.hidden) {
                nameLabelRect.origin.y += add;
            }
            
            moneyLabel.frame = nameLabelRect;
            moneyUtil.frame = CGRectMake(orginx,nameLabelRect.origin.y , moneyUtil.frame.size.width, moneyUtil.frame.size.height);
        }
        moneyUtil.hidden = NO;
    }else{
        moneyLabel.text = @"";
        userRange.text = @"";
    }
}

//开奖
-(NSMutableArray *)changeToNextWinNum:(int)oldnum nWinNums:(int)nWinNumc{
    NSMutableArray *showNums = [[NSMutableArray alloc] init];
    
    for (int i = oldnum; i < 12; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",i]];
        [showNums addObject:image];
        if (i == nWinNumc) {
            return showNums;
        }
    }
    
    if (oldnum <= 11) {
        for (int i = oldnum-1; i > 0; i--) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",i]];
            [showNums addObject:image];
            if (i == nWinNumc) {
                return showNums;
            }
        }
    }
    return showNums;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
