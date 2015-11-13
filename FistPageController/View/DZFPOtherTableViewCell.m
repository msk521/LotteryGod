//
//  DZFPOtherTableViewCell.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/5.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZFPOtherTableViewCell.h"

@implementation DZFPOtherTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)jumpAction:(UIButton *)sender {
    self.jumpToController((int)sender.tag);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
