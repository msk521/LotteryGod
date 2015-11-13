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

-(void)replay:(DZAnlyesRespond *)model{
    
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
        }
    }
}

//和值
-(void)replayHZ:(DZAnlyesRespond *)model{
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
        }
    }
}

//胆码
-(void)replayDM:(DZAnlyesRespond *)model{
    selectedDanmaNumbers2 = [[NSMutableArray alloc] init];
    selectedDanmaNumbers3 = [[NSMutableArray alloc] init];
    selectedNumbers = [[NSMutableArray alloc] init];
    anlyesTiteName.text = model.name;
    self.selectedAnlyesName = model.name;
    self.selectedAnlyesPath = model.jsonPath;
    for (UIView *view in anlyesView.subviews) {
        if (view.tag >= 100) {
            [view removeFromSuperview];
        }
    }
    possibleValues = model.possibleValues;
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
    
    int ly = 0;
    for (int m = 0; m < 3; m++) {
        if (m > 0) {
            ly -= 21;
        }
    UILabel *danmaLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 43+ly, 100, 21)];
    danmaLabel.tag = 200;
    danmaLabel.text = [NSString stringWithFormat:@"胆码%d",m + 1];
        danmaLabel.font = [UIFont systemFontOfSize:13.0f];
    float with = anlyesView.frame.size.width / danmaKeysarr2.count;
    with = anlyesView.frame.size.width / 11;
    
    float y = danmaLabel.frame.origin.y + danmaLabel.frame.size.height-2;
    float lastY = 0;
    for (int i = 0; i < danmaKeysarr2.count; i++) {
        NSString *key = danmaKeysarr2[i];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*with, y , with-5, with-5)];
        if (m == 0) {
            [button addTarget:self action:@selector(selectedDMNumber:) forControlEvents:UIControlEventTouchUpInside];
        }else if (m == 1){
            [button addTarget:self action:@selector(selectedDMNumber2:) forControlEvents:UIControlEventTouchUpInside];
        }else if (m == 2){
            [button addTarget:self action:@selector(selectedDMNumber3:) forControlEvents:UIControlEventTouchUpInside];
        }
        lastY = button.frame.origin.y + button.frame.size.height;
        button.tag = 101 + i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[key intValue]]] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"grey-little-ball%d",[key intValue]]] forState:UIControlStateNormal];
        [anlyesView addSubview:button];
    }
    
    UILabel *danmaCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, lastY , 100, 21)];
    danmaCountLabel.tag = 201;
        danmaCountLabel.font = [UIFont systemFontOfSize:13.0f];
    danmaCountLabel.text = [NSString stringWithFormat:@"胆码个数%d",m+1];
    float county = danmaCountLabel.frame.origin.y + danmaCountLabel.frame.size.height ;
    for (int i = 0; i < danmaCountKeysarr.count; i++) {
        NSString *key = danmaCountKeysarr[i];
       
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*with, county , with-5, with-5)];
        if (m == 0) {
            [button addTarget:self action:@selector(selectedDMNumber:) forControlEvents:UIControlEventTouchUpInside];
        }else if (m == 1){
            [button addTarget:self action:@selector(selectedDMNumber2:) forControlEvents:UIControlEventTouchUpInside];
        }else if (m == 2){
        [button addTarget:self action:@selector(selectedDMNumber3:) forControlEvents:UIControlEventTouchUpInside];
        }
        button.tag = 300 + i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[key intValue]]] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"grey-little-ball%d",[key intValue]]] forState:UIControlStateNormal];
        [anlyesView addSubview:button];
    }
        ly = lastY+ 21;
    [anlyesView addSubview:danmaCountLabel];
    [anlyesView addSubview:danmaLabel];
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

//胆码1
-(void)selectedDMNumber:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    NSString *key = @"";
    if (sender.tag < 300) {
        if (sender.tag - 100 >= 10) {
            key = [NSString stringWithFormat:@"胆码%d",(int)sender.tag - 100];
        }else{
            key = [NSString stringWithFormat:@"胆码0%d",(int)sender.tag - 100];
        }
    }else{
        key = [NSString stringWithFormat:@"胆码个数%d",(int)sender.tag - 300];
    }
    if (sender.selected) {
        [selectedNumbers addObject:key];
    }else{
        if ([selectedNumbers containsObject:key]) {
            [selectedNumbers removeObject:key];
        }
    }
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    if (selectedNumbers.count > 0) {
        [resultStr appendFormat:@"%@",[selectedNumbers componentsJoinedByString:@","]];
    }
    if (selectedDanmaNumbers2.count > 0) {
        [resultStr appendFormat:@"|%@",[selectedDanmaNumbers2 componentsJoinedByString:@","]];
    }
    if (selectedDanmaNumbers3.count > 0) {
        [resultStr appendFormat:@"|%@",[selectedDanmaNumbers3 componentsJoinedByString:@","]];
    }
    self.selectedResult = resultStr;
}

//胆码2
-(void)selectedDMNumber2:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    NSString *key = @"";
    if (sender.tag < 300) {
        
        if (sender.tag - 100 >= 10) {
            key = [NSString stringWithFormat:@"胆码%d",(int)sender.tag - 100];
        }else{
            key = [NSString stringWithFormat:@"胆码0%d",(int)sender.tag - 100];
        }
        
    }else{
        key = [NSString stringWithFormat:@"胆码个数%d",(int)sender.tag - 300];
    }
    if (sender.selected) {
        [selectedDanmaNumbers2 addObject:key];
    }else{
        if ([selectedDanmaNumbers2 containsObject:key]) {
            [selectedDanmaNumbers2 removeObject:key];
        }
    }
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    if (selectedNumbers.count > 0) {
        [resultStr appendFormat:@"%@",[selectedNumbers componentsJoinedByString:@","]];
    }
    if (selectedDanmaNumbers2.count > 0) {
        [resultStr appendFormat:@"|%@",[selectedDanmaNumbers2 componentsJoinedByString:@","]];
    }
    if (selectedDanmaNumbers3.count > 0) {
        [resultStr appendFormat:@"|%@",[selectedDanmaNumbers3 componentsJoinedByString:@","]];
    }
    self.selectedResult = resultStr;
}

//胆码3
-(void)selectedDMNumber3:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    NSString *key = @"";
    if (sender.tag < 300) {
        if (sender.tag - 100 >= 10) {
            key = [NSString stringWithFormat:@"胆码%d",(int)sender.tag - 100];
        }else{
            key = [NSString stringWithFormat:@"胆码0%d",(int)sender.tag - 100];
        }
    }else{
        key = [NSString stringWithFormat:@"胆码个数%d",(int)sender.tag - 300];
    }
    if (sender.selected) {
        [selectedDanmaNumbers3 addObject:key];
    }else{
        if ([selectedDanmaNumbers3 containsObject:key]) {
            [selectedDanmaNumbers3 removeObject:key];
        }
    }
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    if (selectedNumbers.count > 0) {
        [resultStr appendFormat:@"%@",[selectedNumbers componentsJoinedByString:@","]];
    }
    if (selectedDanmaNumbers2.count > 0) {
        [resultStr appendFormat:@"|%@",[selectedDanmaNumbers2 componentsJoinedByString:@","]];
    }
    if (selectedDanmaNumbers3.count > 0) {
        [resultStr appendFormat:@"|%@",[selectedDanmaNumbers3 componentsJoinedByString:@","]];
    }
    self.selectedResult = resultStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
