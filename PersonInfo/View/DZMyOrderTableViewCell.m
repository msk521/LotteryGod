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
    //订单金额
    __weak IBOutlet UILabel *orderMoney;
    //共多少期
    __weak IBOutlet UILabel *poids;
    //彩种名称
    __weak IBOutlet UILabel *lottryName;
    //创建时间
    __weak IBOutlet UILabel *createTimeLabel;
    //撤单
    __weak IBOutlet UIButton *cancelOrderButton;
    DZMyOrderListRespond *currentRespond;
    __weak IBOutlet UIView *backView;
    //开始期号
    __weak IBOutlet UILabel *startPoidNum;
    //分析条件
    __weak IBOutlet UILabel *anlyesInfo;
}
@end
@implementation DZMyOrderTableViewCell

- (void)awakeFromNib {
    backView.layer.cornerRadius = 5.0f;
    backView.layer.masksToBounds = YES;
}

-(void)replay:(DZMyOrderListRespond *)respond{
    currentRespond = respond;
    //开始期号
    NSDictionary *firstPoids = [respond.details firstObject];
    if (firstPoids) {
            startPoidNum.text = [NSString stringWithFormat:@"开始期号:%@",firstPoids[@"period"]];
    }else{
        startPoidNum.text = [NSString stringWithFormat:@"开始期号:%@",respond.currentPeriod];
    }

    //奖金
    if (respond.totalProfit && respond.totalProfit.length == 0) {
        winMoney.text = @"未开奖";
    }else if (respond.totalProfit && [respond.totalProfit floatValue] == 0) {
         winMoney.text = @"未中奖";
    }else{
        winMoney.text = [NSString stringWithFormat:@"奖金:%@",respond.totalProfit];
    }
   
    //投注金额
    orderMoney.text = [NSString stringWithFormat:@"投注金额:%@元",respond.totalPrincipal];
    //追号期数
     poids.text = [NSString stringWithFormat:@"追号期数:%@期",respond.totalPeriods];
    //彩种
    lottryName.text = [NSString stringWithFormat:@"彩种:%@",respond.lotteryName];
    //创建时间
    createTimeLabel.text = [NSString stringWithFormat:@"下单时间:%@",respond.createTime];
    
    if (respond.finished.intValue == 0) {
        cancelOrderButton.hidden = NO;
    }else{
        cancelOrderButton.hidden = YES;
    }
}

//查看投注详情
- (IBAction)lookBuyDetail:(UIButton *)sender {
    if (self.lookDetail) {
        self.lookDetail(currentRespond);
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
