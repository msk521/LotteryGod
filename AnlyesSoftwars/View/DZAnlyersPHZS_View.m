//
//  DZAnlyersPHZS_View.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/10.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZAnlyersPHZS_View.h"
@interface DZAnlyersPHZS_View(){
    NSArray *sourtedArr;
    NSDictionary *possibleValues;
    //已选
    NSMutableArray *selectedNumbers;
    NSMutableArray *selectedNames;
    __weak IBOutlet UIView *anlyesView;
}
@end
@implementation DZAnlyersPHZS_View

////点击确认
//-(void)shouldSelected{
//    if (self.showView) {
//        self.showView(nil);
//    }
//}

-(void)replay:(DZAnlyesRespond *)model{
    selectedNames = [[NSMutableArray alloc] init];
    selectedNumbers = [[NSMutableArray alloc] init];
    self.selectedAnlyesName = model.name;
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
        if (with > 50) {
            with = 50;
        }
        
      float x = (anlyesView.frame.size.width - with * sourtedArr.count) / 2.0f;
        
        for (int i = 0; i < sourtedArr.count; i++) {
            NSString *key = sourtedArr[i];
            NSString *value = possibleValues[key];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x+i*with, anlyesView.frame.size.height / 2 , with-10, with-10)];
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

-(void)selectedNumber:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    NSString *key = sourtedArr[sender.tag - 100];
    if (sender.selected) {
        [selectedNumbers addObject:key];
        [selectedNames addObject:possibleValues[key]];
    }else{
        if ([selectedNumbers containsObject:key]) {
            [selectedNumbers removeObject:key];
            [selectedNames removeObject:possibleValues[key]];
        }
    }
    
    self.selectedResult = [selectedNumbers componentsJoinedByString:@","];
    self.phzsNames = [selectedNames componentsJoinedByString:@","];
}


@end
