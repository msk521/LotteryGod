//
//  DZOrderDetailTableViewCell.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/16.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZOrderDetailTableViewCell.h"
@interface DZOrderDetailTableViewCell(){
    //序号
    __weak IBOutlet UILabel *numberLabel;
    //期号
    __weak IBOutlet UILabel *poidsNumberLabel;
    //当前投入
    __weak IBOutlet UILabel *currentBuyMoney;
    //累计投入
    __weak IBOutlet UILabel *totalBuyMoney;
    //中奖金额
    __weak IBOutlet UILabel *winMoney;
    //中奖号码
    __weak IBOutlet UILabel *currentWinNumberLabl;
}
@end
@implementation DZOrderDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)replay:(NSDictionary *)dic number:(int)row{
        self.backgroundColor = COLOR(229, 230, 231);
    if (row % 2 == 0) {
        self.backgroundColor = [UIColor whiteColor];
    }
    NSString *poids = [NSString stringWithFormat:@"%@期",dic[@"period"]];
    //序号
    numberLabel.text = [NSString stringWithFormat:@"%d",row];
    //第多少期
    poidsNumberLabel.text = [poids substringFromIndex:poids.length - 5];
    //开奖号码
    NSString *winNumber = dic[@"lotteryNumbers"];
    NSString *win = [winNumber stringByReplacingOccurrencesOfString:@"," withString:@"  "];
    currentWinNumberLabl.text = [NSString stringWithFormat:@"开奖号码: %@",win];
    //当期投入
    currentBuyMoney.text = [NSString stringWithFormat:@"%@元",dic[@"totalPrincipal"]];
    //累计投入
    totalBuyMoney.text  = [NSString stringWithFormat:@"%@元",dic[@"cumulativePrincipal"]];
    //中奖金额
    numberLabel.textColor = COLOR(51, 51, 51);
    poidsNumberLabel.textColor = COLOR(51, 51, 51);
    currentBuyMoney.textColor = COLOR(51, 51, 51);
    totalBuyMoney.textColor = COLOR(51, 51, 51);
    winMoney.textColor = COLOR(51, 51, 51);
    currentWinNumberLabl.textColor = COLOR(51, 51, 51);
    winMoney.textColor = [UIColor grayColor];
    if (!dic[@"totalProfit"] || [dic[@"totalProfit"] length] == 0 ) {
        winMoney.text = @"未开奖";
        if ([dic[@"canceled"] intValue] == 1) {
            winMoney.text = @"已撤单";
        }
    }else{
        winMoney.text = [NSString stringWithFormat:@"¥%@",dic[@"totalProfit"]];
        if ([dic[@"totalProfit"] floatValue] > 0) {
            numberLabel.textColor = [UIColor redColor];
            poidsNumberLabel.textColor = [UIColor redColor];
            currentBuyMoney.textColor = [UIColor redColor];
            totalBuyMoney.textColor = [UIColor redColor];
            winMoney.textColor = [UIColor redColor];
            currentWinNumberLabl.textColor = [UIColor redColor];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
