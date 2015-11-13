//
//  DZMyOrderTableViewCell.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/1.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZMyOrderTableViewCell.h"
@interface DZMyOrderTableViewCell(){
    //中奖金额
    __weak IBOutlet UILabel *winMoney;
    //中奖状态
    __weak IBOutlet UILabel *winState;
    //订单金额
    __weak IBOutlet UILabel *orderMoney;
    //共多少期
    __weak IBOutlet UILabel *poids;
    //订单号
    __weak IBOutlet UILabel *orderid;
    //彩种名称
    __weak IBOutlet UILabel *lottryName;
    //创建时间
    __weak IBOutlet UILabel *createTimeLabel;
    //撤单
    __weak IBOutlet UIButton *cancelOrderButton;
    DZMyOrderListRespond *currentRespond;
    __weak IBOutlet UILabel *currentZhuiQi;
}
@end
@implementation DZMyOrderTableViewCell

- (void)awakeFromNib {
    
}

-(void)replay:(DZMyOrderListRespond *)respond{
    currentRespond = respond;
    lottryName.text = respond.lotteryName;
    orderid.text = [NSString stringWithFormat:@"订单号:%@",respond.id];
    NSString *distion = @"(中奖后撤单)";
    if (respond.autoCancelOrderWhenWinning == 0) {
        distion = @"";
    }
    createTimeLabel.text = [NSString stringWithFormat:@"创建时间:%@",respond.createTime];
    currentZhuiQi.text = [NSString stringWithFormat:@"已追:%@",respond.cancelPeriods];
    poids.text = [NSString stringWithFormat:@"共%@期%@",respond.totalPeriods,distion];
    orderMoney.text = [NSString stringWithFormat:@"%@元",respond.totalPrincipal];
    winMoney.text = [NSString stringWithFormat:@"%@",respond.totalProfit];
    winState.text = respond.status;
    if (respond.finished.intValue == 0) {
        cancelOrderButton.hidden = NO;
    }else{
        cancelOrderButton.hidden = YES;
    }
}

//取消订单
- (IBAction)cancelOrderAction:(UIButton *)sender {
    if(self.cancelOrder){
        self.cancelOrder(currentRespond.id);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
