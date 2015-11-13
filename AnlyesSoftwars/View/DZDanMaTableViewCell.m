//
//  DZDanMaTableViewCell.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/8.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZDanMaTableViewCell.h"
@interface DZDanMaTableViewCell(){
    NSMutableArray *currentSelectedArr;
    NSMutableArray *currentDanmacount;
}
@end
@implementation DZDanMaTableViewCell

- (void)awakeFromNib {
    
}

-(void)replay:(DZAnlyesRespond *)model selectedNumbers:(NSMutableArray *)selectedNumbers danmacount:(NSMutableArray *)danmacount{
    currentSelectedArr = selectedNumbers;
    currentDanmacount = danmacount;
    for (UIView *view in self.contentView.subviews) {
        if (view.tag >= 100) {
            [view removeFromSuperview];
        }
    }
    NSDictionary *possibleValues = model.possibleValues;
    NSArray *allKeys = [possibleValues allKeys];
    NSMutableArray *danmaKeys = [[NSMutableArray alloc] init];
    NSMutableArray *danmaCountKeys = [[NSMutableArray alloc] init];
    NSString *danmaCountStr = @"danmaCount";
    NSString *danmaStr = @"danma";
    for (NSString *key in allKeys) {
        if ([key rangeOfString:@"danmaCount"].location != NSNotFound) {
            [danmaCountKeys addObject:[key substringFromIndex:danmaCountStr.length]];
        }else{
            [danmaKeys addObject:[key substringFromIndex:danmaStr.length]];
        }
    }
    
    NSArray *danmaCountKeysarr = [danmaCountKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *intStr1 = (NSString *)obj1;
        NSString *intStr2 = (NSString *)obj2;
        return intStr2.intValue<intStr1.intValue;
    }];
    
    NSArray *danmaKeysarr2 = [danmaKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *intStr1 = (NSString *)obj1;
        NSString *intStr2 = (NSString *)obj2;
        return intStr2.intValue<intStr1.intValue;
    }];
    
    float lastY = 0;
    
    CGRect rect = self.bounds;
    float addx = (rect.size.width - 40 * 6) / 6;
    float x = 0;
    float y = 0;
    
    for (int i = 0; i < danmaKeysarr2.count; i++) {
        x = i;
        if (i >= 6) {
            y = 1;
            x -= 6;
        }
        if (i == 6) {
            
        }
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x*(40+addx) + addx/2, 48 * y + 8 , 40, 40)];
        button.layer.cornerRadius = 20;
        button.layer.masksToBounds = YES;
        lastY = button.frame.origin.y + button.frame.size.height+8;
        button.tag = 101 + i;
        
        if (i >= 9) {
            [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        }else{
            [button setTitle:[NSString stringWithFormat:@"0%d",i+1] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(selectedNumber:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"circle-hover"] forState:UIControlStateSelected];
        NSString *titleLabel = [button titleForState:UIControlStateNormal];
        if ([currentSelectedArr containsObject:titleLabel]) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        [self.contentView addSubview:button];
    }
    
    UILabel *danmaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lastY, self.bounds.size.width, 21)];
    danmaLabel.textAlignment = NSTextAlignmentCenter;
    danmaLabel.tag = 200;
    danmaLabel.text = @"胆码个数:";
    [self.contentView addSubview:danmaLabel];
    lastY = lastY + 29;
    x = 0;
    for (int i = 0; i < danmaCountKeysarr.count; i++) {
        x = i;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x*(40+addx) + addx/2, lastY , 40, 40)];
        [button addTarget:self action:@selector(selectedNumber:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 20;
        button.layer.masksToBounds = YES;
        [button setTitle:[NSString stringWithFormat:@"0%d",i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.tag = 300 + i;
        [button setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"circle-hover"] forState:UIControlStateSelected];
        if ([currentDanmacount containsObject:[NSString stringWithFormat:@"0%d",i+1]]) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        [self.contentView addSubview:button];
    }

}

-(void)selectedNumber:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (sender.tag < 200) {
        //胆码
        NSString *titleLabel = [sender titleForState:UIControlStateNormal];
        [currentSelectedArr removeObject:[NSString stringWithFormat:@"danma%@",titleLabel]];
        [currentSelectedArr addObject:[NSString stringWithFormat:@"danma%@",titleLabel]];
    }else if(sender.tag >= 300){
        //胆码个数
        NSString *titleLabel = [sender titleForState:UIControlStateNormal];
        [currentDanmacount removeObject:[NSString stringWithFormat:@"danmaCount%d",titleLabel.intValue]];
        [currentDanmacount addObject:[NSString stringWithFormat:@"danmaCount%d",titleLabel.intValue]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
