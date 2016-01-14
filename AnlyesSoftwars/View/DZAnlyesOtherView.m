//
//  DZAnlyesOtherView.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/22.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZAnlyesOtherView.h"
#import "AppDelegate.h"
@interface DZAnlyesOtherView(){
    __weak IBOutlet UIView *anlyesView;
    __weak IBOutlet UILabel *anlyesTiteName;
    NSArray *sourtedArr;
    NSDictionary *possibleValues;
    //已选
    NSMutableArray *selectedNumbers;
    NSMutableArray *selectedDanmaNumbers2;
    NSMutableArray *selectedDanmaNumbers3;
}
@end

@implementation DZAnlyesOtherView

-(void)replay:(DZAnlyesRespond *)model selectedNumber:(NSString *)selectedNumber{
    NSArray *haveselected = nil;
    if (selectedNumber) {
        haveselected = [selectedNumber componentsSeparatedByString:@","];
    }
    selectedNumbers = [[NSMutableArray alloc] init];
    anlyesTiteName.text = model.name;
    self.selectedAnlyesName = model.name;
    self.selectedResult  = @"";
    self.selectedAnlyesPath = model.jsonPath;
    for (UIView *view in anlyesView.subviews) {
        if (view.tag >= 100) {
            [view removeFromSuperview];
        }
    }
    
   possibleValues = model.possibleValues;
    if (possibleValues) {
        NSArray *keys = [possibleValues allKeys];
   sourtedArr = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *intStr1 = (NSString *)obj1;
        NSString *intStr2 = (NSString *)obj2;
        return intStr2.intValue<intStr1.intValue;
    }];
        float with = anlyesView.frame.size.width / keys.count;
        for (int i = 0; i < sourtedArr.count; i++) {
            NSString *key = sourtedArr[i];
            NSString *value = possibleValues[key];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5+i*with, anlyesView.frame.size.height / 2 , with-10, with-10)];
            [button addTarget:self action:@selector(selectedNumber:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100 + i;
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ball%@",value]] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"grey-little-ball%@",value]] forState:UIControlStateNormal];
            [anlyesView addSubview:button];
            if (selectedNumber && haveselected && [haveselected containsObject:key]) {
                [self selectedNumber:button];
            }
        }
    }
}

//和值
-(void)replayHZ:(DZAnlyesRespond *)model selectedNumber:(NSString *)selectedNumber{
    NSArray *haveselected = nil;
    if (selectedNumber) {
        haveselected = [selectedNumber componentsSeparatedByString:@","];
    }
    selectedNumbers = [[NSMutableArray alloc] init];
    anlyesTiteName.text = model.name;
    self.selectedAnlyesName = model.name;
    self.selectedResult  = @"";
    self.selectedAnlyesPath = model.jsonPath;
    for (UIView *view in anlyesView.subviews) {
        if (view.tag >= 100) {
            [view removeFromSuperview];
        }
    }
    
    possibleValues = model.possibleValues;
    if (possibleValues) {
        NSArray *keys = [possibleValues allKeys];
        sourtedArr = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *intStr1 = (NSString *)obj1;
            NSString *intStr2 = (NSString *)obj2;
            return intStr2.intValue<intStr1.intValue;
        }];
        
        CGRect rect = anlyesView.bounds;
        float with = rect.size.width / 7;
        float x = 0;
        float y = 0;
        for (int i = 0; i < sourtedArr.count; i++) {
            
            x += 1;
            if (i%7 == 0 && i != 0) {
                y = i / 7;
                x = 0;
            }
            
            if (i == 0) {
                x = 0;
            }
            
            NSString *key = sourtedArr[i];
            NSString *value = possibleValues[key];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x*with+2, with * y+with, with-10, with-10)];
            [button addTarget:self action:@selector(selectedNumber:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100 + i;
            [button setBackgroundImage:[UIImage imageNamed:@"circle-hover"] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
            [button setTitle:value forState:UIControlStateNormal];
            [anlyesView addSubview:button];
            if (selectedNumber && haveselected && [haveselected containsObject:key]) {
                [self selectedNumber:button];
            }
        }
    }
}


-(void)selectedNumber:(UIButton *)sender{
        
        sender.selected = !sender.selected;
        NSString *key = sourtedArr[sender.tag - 100];
        if (sender.selected) {
            [selectedNumbers addObject:possibleValues[key]];
        }else{
            if ([selectedNumbers containsObject:possibleValues[key]]) {
                [selectedNumbers removeObject:possibleValues[key]];
            }
        }
        
        self.selectedResult = [selectedNumbers componentsJoinedByString:@","];
    }


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
