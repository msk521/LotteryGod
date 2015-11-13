//
//  DZResultTableViewCell.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/6.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZResultTableViewCell.h"

@implementation DZResultTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)replay:(DZLastWinNumberRespond *)result{
    //期数
    UILabel *dateNum = (UILabel *)[self viewWithTag:200];
    dateNum.text = result.period;
    //时间
    UILabel *time = (UILabel *)[self viewWithTag:201];
    time.text = result.time;
    
    NSArray *winNumbers = [result.numbers componentsSeparatedByString:@","];
    for (int i = 0; i < winNumbers.count; i++) {
        UIImageView *imgView = (UIImageView*)[self viewWithTag:100 + i];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[winNumbers[i] intValue]]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
