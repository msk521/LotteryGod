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

-(void)replay:(DZAnlyesRespond *)model selectedNumber:(NSString *)selectedNumber{

    if (!selectedNames) {
        selectedNames = [[NSMutableArray alloc] init];
    }
    
    if (!selectedNumbers) {
         selectedNumbers = [[NSMutableArray alloc] init];
    }
    if (selectedNumber) {
        self.selectedResult = selectedNumber;
        [self checkSelectedButton:selectedNumber];
    }
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
    }else{
        [selectedNumbers removeObject:selectedValue];
    }

    if (![selectedNames containsObject:selectedName]) {
        [selectedNames addObject:selectedName];
    }else{
        [selectedNames removeObject:selectedName];
    }
    
    self.selectedResult = [selectedNumbers componentsJoinedByString:@","];
    self.selectedName = [selectedNames componentsJoinedByString:@","];
}

//设置已选中状态
-(void)checkSelectedButton:(NSString *)haveSelected{
    NSArray *selecteds = [haveSelected componentsSeparatedByString:@","];
    for (NSString *selectedStr in selecteds) {
        int tag = 0;
        NSString *value = nil;
        NSString *name = nil;
        if ([selectedStr isEqualToString:@"primeHead"]) {
            //龙头质
            value = @"primeHead";
            name = @"龙头质";
            tag = 100;
        }else if ([selectedStr isEqualToString:@"compositeHead"]) {
            //龙头合
            value = @"compositeHead";
            name = @"龙头合";
            tag = 101;
        }else if ([selectedStr isEqualToString:@"primeTail"]) {
            //凤尾质
            value = @"primeTail";
            name = @"凤尾质";
            tag = 102;
        }else if ([selectedStr isEqualToString:@"compositeTail"]) {
            //凤尾合
            value = @"compositeTail";
            name = @"凤尾合";
            tag = 103;
        }else if ([selectedStr isEqualToString:@"prime_composite_xor"]) {
            //出现1
            value = @"prime_composite_xor";
            name = @"1次";
            tag = 104;
        }else if ([selectedStr isEqualToString:@"prime_composite_and"]) {
            //出现2
            value = @"prime_composite_and";
            name = @"2次";
            tag = 105;
        }else if ([selectedStr isEqualToString:@"oddHead"]) {
            //龙头单
            value = @"oddHead";
            name = @"龙头单";
            tag = 106;
        }else if ([selectedStr isEqualToString:@"evenHead"]) {
            //龙头双
            value = @"evenHead";
            name = @"龙头双";
            tag = 107;
        }else if ([selectedStr isEqualToString:@"oddTail"]) {
            //凤尾单
            value = @"oddTail";
            name = @"凤尾单";
            tag = 108;
        }else if ([selectedStr isEqualToString:@"evenTail"]) {
            //凤尾双
            value = @"evenTail";
            name = @"凤尾双";
            tag = 109;
        }else if ([selectedStr isEqualToString:@"odd_even_xor"]) {
             //出现1
            value = @"odd_even_xor";
            name = @"1次";
            tag = 110;
        }else if ([selectedStr isEqualToString:@"odd_even_and"]) {
            //出现2
            value = @"odd_even_and";
            name = @"2次";
            tag = 111;
        }
        if (tag > 0) {
            UIButton *btn = (UIButton *)[anlyesView viewWithTag:tag];
            btn.selected = YES;
            if (![selectedNumbers containsObject:value]) {
                [selectedNumbers addObject:value];
            }
            if (![selectedNames containsObject:name]) {
                [selectedNames addObject:name];
            }
            self.selectedResult = [selectedNumbers componentsJoinedByString:@","];
            self.selectedName = [selectedNames componentsJoinedByString:@","];
        }
    }
}

@end
