
//
//  DZHistoricalTrendCell.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/12.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZHistoricalTrendCell.h"
#import "AppDelegate.h"
#import "MZTimerLabel.h"
@interface DZHistoricalTrendCell(){
    
}
@property (nonatomic,strong) MZTimerLabel *timerExample3;
@property (nonatomic,strong) MZTimerLabel *timerExample4;

@end
@implementation DZHistoricalTrendCell

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restarTime) name:@"restarTime" object:nil];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLOR(245, 245, 245);
        self.contentView.backgroundColor = COLOR(245, 245, 245);
        }
    return self;
}

-(void)initLabels:(NSIndexPath *)indexPath winNum:(DZLastWinNumberRespond *)respond{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    CGRect frame = [UIScreen mainScreen].bounds;
    UIColor *color = [UIColor whiteColor];
    if (indexPath.row % 2 == 0) {
        color = COLOR(244, 244, 244);
    }
    NSArray *arc = [respond.numbers componentsSeparatedByString:@","];
    NSMutableArray *numsArr = [NSMutableArray array];
    for (NSString *num in arc) {
        [numsArr addObject:@(num.intValue)];
    }
    float with = frame.size.width/ 12;
    for (int i = 0; i < 12; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i * with , 0, with - 1, with)];
        lab.backgroundColor = color;
        lab.numberOfLines = 0;
        lab.text = [NSString stringWithFormat:@"%d",i];
        lab.font = [UIFont systemFontOfSize:12.0f];
        lab.textColor = [UIColor lightGrayColor];
        lab.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
           NSString *qh = [respond.period substringFromIndex:respond.period.length - 4];
            if (!iPhone6 && !iPhone6Plus) {
             lab.font = [UIFont systemFontOfSize:11.0f];
            }
            lab.text = qh;
        }
        NSString *num = [NSString stringWithFormat:@"%d",i];
        [self.contentView addSubview:lab];
        if ([numsArr containsObject:@(i)]) {
            UILabel *selectlab = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, with - 10, with - 10)];
            selectlab.backgroundColor = [UIColor redColor];
            selectlab.center = lab.center;
            selectlab.layer.masksToBounds = YES;
            selectlab.layer.cornerRadius = selectlab.frame.size.width / 2.0f;
            selectlab.backgroundColor = COLOR(255, 20, 20);
            selectlab.textAlignment = NSTextAlignmentCenter;
            selectlab.textColor = [UIColor whiteColor];
            selectlab.font = [UIFont systemFontOfSize:12.0f];
            selectlab.text = num;
            
            [self.contentView addSubview:selectlab];
        }
    }
}

//求出平均出现次数
-(void)initLabelsWithAppears:(NSMutableDictionary *)dataSource{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    CGRect frame = [UIScreen mainScreen].bounds;
    UIColor *color = COLOR(244, 244, 244);
    float with = frame.size.width/ 12;
    for (int i = 0; i < 12; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i * with , 0, with - 1, with)];
        lab.backgroundColor = color;
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:12.0f];
        lab.textColor = [UIColor lightGrayColor];
        lab.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            NSString *qh = @"出现次数";
            if (!iPhone6 && !iPhone6Plus) {
                lab.font = [UIFont systemFontOfSize:11.0f];
            }
            lab.text = qh;
        }else{
            NSMutableArray *numbers = dataSource[@(i)];
            lab.text = [NSString stringWithFormat:@"%d",(int)numbers.count];
        }
        [self.contentView addSubview:lab];
    }
}

//求最大遗漏
-(void)initLabelsWithYL:(NSArray *)dataSource{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    CGRect frame = [UIScreen mainScreen].bounds;
    UIColor *color = [UIColor whiteColor];
    float with = frame.size.width/ 12;
    for (int i = 0; i < 12; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i * with , 0, with - 1, with)];
        lab.backgroundColor = color;
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:12.0f];
        lab.textColor = [UIColor lightGrayColor];
        lab.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            NSString *qh = @"最大遗漏";
            if (!iPhone6 && !iPhone6Plus) {
                lab.font = [UIFont systemFontOfSize:11.0f];
            }
            lab.text = qh;
        }else{
            NSNumber *number= dataSource[i-1];
            lab.text = [NSString stringWithFormat:@"%d",number.intValue];
        }
        [self.contentView addSubview:lab];
    }
}

//求平均遗漏
-(void)initLabelsWithAdv:(NSArray *)dataSource{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    CGRect frame = [UIScreen mainScreen].bounds;
    UIColor *color = COLOR(244, 244, 244);
    float with = frame.size.width/ 12;
    for (int i = 0; i < 12; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i * with , 0, with - 1, with)];
        lab.backgroundColor = color;
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:12.0f];
        lab.textColor = [UIColor lightGrayColor];
        lab.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            NSString *qh = @"平均遗漏";
            if (!iPhone6 && !iPhone6Plus) {
                lab.font = [UIFont systemFontOfSize:11.0f];
            }
            lab.text = qh;
        }else{
            NSNumber *number= dataSource[i-1];
            lab.text = [NSString stringWithFormat:@"%d",number.intValue];
        }
        [self.contentView addSubview:lab];
    }
}

//求最大连击
-(void)initLabelsWithBigLJ:(NSArray *)dataSource{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    CGRect frame = [UIScreen mainScreen].bounds;
    UIColor *color = [UIColor whiteColor];
    float with = frame.size.width/ 12;
    for (int i = 0; i < 12; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i * with , 0, with - 1, with)];
        lab.backgroundColor = color;
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:12.0f];
        lab.textColor = [UIColor lightGrayColor];
        lab.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            NSString *qh = @"最大连击";
            if (!iPhone6 && !iPhone6Plus) {
                lab.font = [UIFont systemFontOfSize:11.0f];
            }
            lab.text = qh;
        }else{
            NSNumber *number= dataSource[i-1];
            lab.text = [NSString stringWithFormat:@"%d",number.intValue];
        }
        [self.contentView addSubview:lab];
    }
}

//当前剩余开奖时间
-(void)initLabelsWithLowShowWinNumber:(NSNumber *)dataSource{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    CGRect frame = [UIScreen mainScreen].bounds;
    float with = frame.size.width/ 12;
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width/2, with)];
    timeLabel.textColor = COLOR(80, 80, 80);
    timeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self resetTimer:dataSource.intValue label:timeLabel];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timeLabel];
    
    UILabel *lastTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-20, 0, frame.size.width/2, with)];
    lastTimeLabel.textColor = COLOR(80, 80, 80);
    lastTimeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self touzhuTimer:dataSource.intValue label:lastTimeLabel];
    lastTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:lastTimeLabel];
}

//投注剩余倒计时
-(void)touzhuTimer:(int)sec label:(UILabel *)lastTime{
    AppDelegate *main = [UIApplication sharedApplication].delegate;
    self.timerExample4 = [[MZTimerLabel alloc] initWithLabel:lastTime andTimerType:MZTimerLabelTypeTimer];
    if (sec > MINUES) {
        [self.timerExample4 setCountDownTime:sec-MINUES];
    }else{
        [self.timerExample4 setCountDownTime:0];
    }

    self.timerExample4.timeFormat = @"剩余投注时间 mm分ss秒 ";
    if (main.shouldAgainRequestWinNumber) {
        NSInteger minus = [DZUtile checkMinus];
        if (minus <= 600) {
            self.timerExample4.timeFormat = @" 剩余投注时间 mm分ss秒 ";
        }else{
            self.timerExample4.timeFormat = @" 剩余开奖时间 hh时mm分ss秒 ";
        }
        if (minus > MINUES) {
            [self.timerExample4 setCountDownTime:minus - MINUES];
        }else{
            [self.timerExample4 setCountDownTime:0];
        }
    }
    [self.timerExample4 start];
}

//剩余倒计时
-(void)resetTimer:(int)sec label:(UILabel *)lastTime{
    AppDelegate *main = [UIApplication sharedApplication].delegate;
    self.timerExample3 = [[MZTimerLabel alloc] initWithLabel:lastTime andTimerType:MZTimerLabelTypeTimer];
    [self.timerExample3 setCountDownTime:sec];
    self.timerExample3.timeFormat = @" 剩余开奖时间 mm分ss秒 ";
    if (main.shouldAgainRequestWinNumber) {
        NSInteger minus = [DZUtile checkMinus];
        if (minus <= 600) {
            self.timerExample3.timeFormat = @" 剩余开奖时间 mm分ss秒 ";
            self.timerExample4.timeFormat = @" 剩余投注时间 mm分ss秒 ";
        }else{
            self.timerExample3.timeFormat = @" 剩余开奖时间 hh时mm分ss秒 ";
            self.timerExample4.timeFormat = @" 剩余开奖时间 hh时mm分ss秒 ";
        }
       [self.timerExample3 setCountDownTime:minus];
        
        if (minus > MINUES) {
            [self.timerExample4 setCountDownTime:minus - MINUES];
        }else{
            [self.timerExample4 setCountDownTime:0];
        }
    }
    
    [self.timerExample3 start];
}

//重新倒计时
-(void)restarTime{
    if (self.timerExample3) {
        //剩余开奖时间
        AppDelegate *main = [UIApplication sharedApplication].delegate;
        NSString *currentTime = main.currentTime;
        NSString *secStr = [[currentTime componentsSeparatedByString:@":"] firstObject];
        NSString *mecStr = [[currentTime componentsSeparatedByString:@":"] lastObject];
        [self.timerExample3 setCountDownTime:(secStr.intValue * 60 + mecStr.intValue)];
        [self.timerExample3 start];
        if ((secStr.intValue * 60 + mecStr.intValue) > MINUES) {
            [self.timerExample4 setCountDownTime:(secStr.intValue * 60 + mecStr.intValue) - MINUES];
            [self.timerExample4 start];
        }else{
            [self.timerExample4 setCountDownTime:0];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
