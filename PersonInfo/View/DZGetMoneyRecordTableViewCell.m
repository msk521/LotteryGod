//
//  DZGetMoneyRecordTableViewCell.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/11.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZGetMoneyRecordTableViewCell.h"
@interface DZGetMoneyRecordTableViewCell(){
    //创建时间
    __weak IBOutlet UILabel *createTime;
    //提现状态
    __weak IBOutlet UILabel *statusLabel;
    //提现卡号
    __weak IBOutlet UILabel *bankNumber;
    //持卡人姓名
    __weak IBOutlet UILabel *bankCarsName;
    //提现金额
    __weak IBOutlet UILabel *receiveMoney;
}
@end
@implementation DZGetMoneyRecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)replay:(DZGetMoneyRecordRespond *)respond{
    createTime.text = respond.createTime;
    statusLabel.text = respond.status;
    bankCarsName.text = respond.bankRegisteredName;
    bankNumber.text = [NSString stringWithFormat:@"%@尾号%@",respond.bankName,[respond.bankCardNumber substringFromIndex:respond.bankCardNumber.length - 4]];
    receiveMoney.text = [NSString stringWithFormat:@"¥%@",respond.amount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
