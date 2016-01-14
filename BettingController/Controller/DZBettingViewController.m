//
//  DZBettingViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/8.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Pingpp.h>
#import "DZBettingView.h"
#import "MZTimerLabel.h"
#import "DZCharge.h"
#import "AppDelegate.h"
#import <NSDictionary+RequestEncoding.h>
#import "DZShouldBuyViewController.h"
@interface DZBettingViewController ()<UIActionSheetDelegate,MZTimerLabelDelegate>{
    DZBettingView *bettingView;
    MZTimerLabel *timerExample3;
    UIActionSheet *actionSheet;
    UIActionSheet *channelActionSheet;
    SystemSoundID soundID;
    NSString *channel;
    NSString *principal;
}

@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UILabel *woringLabel;
@property (weak, nonatomic) IBOutlet UIView *toolView;
//共多少注
@property (weak, nonatomic) IBOutlet UILabel *totalNumbers;
@property (nonatomic,copy) NSString *allCount;
//共多少钱
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
//第多少期
@property (weak, nonatomic) IBOutlet UILabel *willWinNumberDate;
//剩余时间
@property (weak, nonatomic) IBOutlet UILabel *lastTime;
//选中号码
@property (nonatomic,strong) NSArray *selectedNumber;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DZBettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *main = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [main.selectedAnlyes removeAllObjects];
    self.willWinNumberDate.text = [NSString stringWithFormat:@"%d期",(int)([self.currentRespond.period doubleValue] + 1)];
    NSDictionary *playDic = [[DZAllCommon shareInstance].currentLottyKind.plays lastObject];
    principal = playDic[@"principal"];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    [self resetTime];
    [self addSelectedNumberView];
    self.woringLabel.text = [NSString stringWithFormat:@"至少选择5个号码，猜中开奖号码任意5个数字即可中奖%@元。",playDic[@"profit"]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@-投注",[DZAllCommon shareInstance].currentLottyKind.name];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTime) name:@"RestTimerNotification" object:nil];
}

//剩余倒计时
-(void)resetTime{
    
    AppDelegate *main = [UIApplication sharedApplication].delegate;
    NSString *currentTime = main.currentTime;
    NSString *secStr = [[currentTime componentsSeparatedByString:@":"] firstObject];
    NSString *mecStr = [[currentTime componentsSeparatedByString:@":"] lastObject];
    if (!timerExample3) {
        timerExample3 = [[MZTimerLabel alloc] initWithLabel:self.lastTime andTimerType:MZTimerLabelTypeTimer];
        timerExample3.delegate = self;
        timerExample3.timeFormat = @"mm:ss";
    }
    if (main.shouldAgainRequestWinNumber) {
        NSInteger minus = [DZUtile checkMinus];
        if (minus <= 600) {
            timerExample3.timeFormat = @"mm:ss";
        }else{
            timerExample3.timeFormat = @"hh:mm:ss";
        }
        if (minus > MINUES) {
            [timerExample3 setCountDownTime:minus - MINUES];
        }else{
            [timerExample3 setCountDownTime:0];
        }
    }else{
        int time = secStr.intValue * 60 + mecStr.intValue;
        if (time > MINUES) {
            [timerExample3 setCountDownTime:time - MINUES];
        }else{
            [timerExample3 setCountDownTime:0];
        }
    }

    [timerExample3 start];
}


#pragma mark---MZTimerLabelDelegate

-(void)timerLabel:(MZTimerLabel*)timerLabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType;
{
    
}

-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    //刷新当前开奖情况
    self.willWinNumberDate.text = [NSString stringWithFormat:@"%d期",(int)([self.willWinNumberDate.text doubleValue] + 1)];
    NSInteger intervalTime = [DZAllCommon shareInstance].currentLottyKind.intervalTime.intValue;
    [timerExample3 setCountDownTime:intervalTime - MINUES];
    [timerExample3 start];
}

#pragma mark --
#pragma mark -- 摇一摇机选
- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    NSLog(@"检测到摇动");
    AudioServicesPlaySystemSound (soundID);
    bettingView._refreshData = YES;
    [bettingView motionBeganing];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    NSLog(@"摇动取消");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"摇动结束");
    if(motion==UIEventSubtypeMotionShake)
    {
        AudioServicesPlaySystemSound (soundID);
    }
    [bettingView motionEnded];
}

-(void)addSelectedNumberView{
    __weak DZBettingViewController *main = self;
    bettingView = [[DZBettingView alloc] init];
    bettingView.frame = CGRectMake(0, self.woringLabel.frame.origin.y + self.woringLabel.frame.size.height, self.view.frame.size.width, self.toolView.frame.origin.y - self.woringLabel.frame.origin.y - self.woringLabel.frame.size.height);
    bettingView.selectedNumbs = ^(NSInteger numbers,NSInteger allMoney,NSMutableArray *dataSource){
        main.selectedNumber = dataSource;
        main.totalNumbers.text = [NSString stringWithFormat:@"共%d注",(int)numbers];
        main.allCount = [NSString stringWithFormat:@"%d",(int)numbers];
        main.totalMoney.text = [NSString stringWithFormat:@"%d元",(int)allMoney];
    };
    [self.view addSubview:bettingView];
    [self.view bringSubviewToFront:self.toolView];
}

//摇一摇
- (IBAction)motionDevice:(id)sender {
    if (bettingView) {
         AudioServicesPlaySystemSound (soundID);
        bettingView._refreshData = YES;
        [bettingView motionBeganing];
    }
}

//清空
- (IBAction)cleanSelected:(id)sender {
    if (bettingView) {
        [bettingView cleanAllSelected];
    }
}

//任选
- (IBAction)selectedAnyNumb:(id)sender {
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"任选5位" otherButtonTitles:@"任选6位",@"任选7位",@"任选8位",@"任选9位",@"任选10位",@"任选11位", nil];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

//确定购买
- (IBAction)shouldBuy:(id)sender {
    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
    if (!userInfoMation.account || userInfoMation.account.length == 0) {
        DZLoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"DZLoginViewController"];
        [DZUtile showLoginViewController:loginView animation:YES finishLoading:^{
            
        }hiddenFinish:^{
            
        }];
    }else{
        if (self.totalMoney.text.intValue == 0) {
            //如果未购买
            [DZUtile showAlertViewWithMessage:@"请至少选择5位要投注的号码"];
            return;
        }
        DZShouldBuyViewController *shouldBuy = [self.storyboard instantiateViewControllerWithIdentifier:@"DZShouldBuyViewController"];
        shouldBuy.money = [NSString stringWithFormat:@"%d",[self.totalMoney.text intValue]];
        shouldBuy.currentPoids = self.willWinNumberDate.text;
        shouldBuy.isLookResult = NO;
        shouldBuy.totalCount = self.allCount;
        shouldBuy.selectedArr = self.selectedNumber;
        shouldBuy.howMoney = principal;
        [self.navigationController pushViewController:shouldBuy animated:YES];
        }
}

#pragma mark---UIActionDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
   if (bettingView) {
        bettingView._refreshData = YES;
        [bettingView selectedAnyNumbersWith:(int)buttonIndex + 5];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
