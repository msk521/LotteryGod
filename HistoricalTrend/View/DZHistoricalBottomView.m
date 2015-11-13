//
//  DZHistoricalBottomView.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/2.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZHistoricalBottomView.h"
@interface DZHistoricalBottomView(){

    NSMutableArray *selectedNumbers;
    //已选情况
    __weak IBOutlet UILabel *haveSelected;
    int totalCount;
}
@end
@implementation DZHistoricalBottomView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        selectedNumbers = [[NSMutableArray alloc] init];
        CGRect frame = [UIScreen mainScreen].bounds;

        float with = frame.size.width / 12;
        for (int i = 0; i < 12; i++) {
            if (i == 0) {
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, with, with)];
                lab.text = @"投注";
                lab.font = [UIFont systemFontOfSize:13.0f];
                lab.textColor = COLOR(51, 51, 51);
                lab.textAlignment = NSTextAlignmentCenter;
                [self addSubview:lab];
                continue;
            }
            UIButton *ball = [[UIButton alloc] init];
            ball.frame = CGRectMake(i * with, 8, with, with);
            ball.tag = 200 + i;
            if (i >= 10) {
            [ball setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
            }else{
            [ball setTitle:[NSString stringWithFormat:@"0%d",i] forState:UIControlStateNormal];
            }
            UIColor *nomalColor = COLOR(153, 153, 153);
            [ball setTitleColor:nomalColor forState:UIControlStateNormal];
            [ball setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [ball setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
            [ball setBackgroundImage:[UIImage imageNamed:@"circle-hover"] forState:UIControlStateSelected];
            [ball addTarget:self action:@selector(selectNumber:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:ball];
        }
    }
    return self;
}

-(void)selectNumber:(UIButton *)sender{
    sender.selected = !sender.selected;
    [selectedNumbers removeObject:@(sender.tag - 200)];
    if (sender.selected) {
        [selectedNumbers addObject:@(sender.tag - 200)];
    }
    
    if (selectedNumbers.count >=5) {
        NSDictionary *playDic = [[DZAllCommon shareInstance].currentLottyKind.plays lastObject];
        float principal = [playDic[@"principal"] floatValue];
        NSInteger totalNumber = 1;
        totalNumber *= [selectedNumbers count];
        double tNum = [self jcWithNumber:totalNumber];
        double bNum = [self jcWithNumber:5];
        double nu = [self jcWithNumber:(totalNumber - 5)];
        int totalNumbers = tNum/(bNum * nu);
        totalCount = totalNumbers;
        haveSelected.text = [NSString stringWithFormat:@"%d注%.2f元",totalNumbers,totalNumbers * principal];
    }
}

-(double)jcWithNumber:(NSInteger)num{
    double totalNum = 1;
    int number = (int)num;
    for (int i = number; i >=1; i--) {
        totalNum *= i;
    }
    return (double)totalNum;
}


- (IBAction)btnSelectedAction:(UIButton *)sender {
    if (self.btnSelected) {
        self.btnSelected((int)sender.tag,selectedNumbers,totalCount);
    }
}

@end
