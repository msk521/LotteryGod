//
//  DZAnylersLTFW_View.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/10.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZAnylersLTFW_View.h"
@interface DZAnylersLTFW_View(){
    NSMutableArray *selectedNumbers;
    NSMutableArray *selectedNames;
    __weak IBOutlet UIView *anlyesView;
}
@end
@implementation DZAnylersLTFW_View
////点击确认
//-(void)shouldSelected{
//    if (self.showView) {
//        self.showView(nil);
//    }
//}

-(void)replay:(DZAnlyesRespond *)model{
    for (UIView *view in anlyesView.subviews) {
        if (view.tag >= 100) {
            UIButton *btn = (UIButton *)view;
            btn.selected = NO;
        }
    }
    selectedNames = [[NSMutableArray alloc] init];
    selectedNumbers = [[NSMutableArray alloc] init];
    self.selectedAnlyesName = model.name;
    self.selectedAnlyesPath = model.jsonPath;
}

- (IBAction)selectedLTFW:(UIButton *)sender {
   
    sender.selected = !sender.selected;

    NSString *selectedValue = @"";
    NSString *selectedName = @"";
    switch (sender.tag) {
        case 100:
            //龙头质
            selectedValue = @"primeHead";
            selectedName = @"龙头质";
            break;
        case 101:
            //龙头合
            selectedValue = @"compositeHead";
            selectedName = @"龙头合";
            break;
        case 102:
            //凤尾质
            selectedValue = @"primeTail";
            selectedName = @"凤尾质";
            break;
        case 103:
            //凤尾合
            selectedValue = @"compositeTail";
            selectedName = @"凤尾合";
            break;
        case 104:
            //出现1
            selectedValue = @"prime_composite_xor";
            selectedName = @"1次";
            break;
        case 105:
            //出现2
            selectedValue = @"prime_composite_and";
            selectedName = @"2次";
            break;
        case 106:
            //龙头单
            selectedValue = @"oddHead";
            selectedName = @"龙头单";
            break;
        case 107:
            //龙头双
            selectedValue = @"evenHead";
            selectedName = @"龙头双";
            break;
        case 108:
            //凤尾单
            selectedValue = @"oddTail";
            selectedName = @"凤尾单";
            break;
        case 109:
            //凤尾双
            selectedValue = @"evenTail";
            selectedName = @"凤尾双";
            break;
        case 110:
            //出现1
            selectedValue = @"odd_even_xor";
            selectedName = @"1次";
            break;
        case 111:
            //出现2
            selectedValue = @"odd_even_and";
            selectedName = @"2次";
            break;
        default:
            break;
    }
    
    if (![selectedNumbers containsObject:selectedValue]) {
        [selectedNumbers addObject:selectedValue];
    }
    if (![selectedNames containsObject:selectedName]) {
        [selectedNames addObject:selectedName];
    }
    self.selectedResult = [selectedNumbers componentsJoinedByString:@","];
    self.selectedName = [selectedNames componentsJoinedByString:@","];
}





@end
