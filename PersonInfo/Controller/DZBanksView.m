//
//  DZBanksView.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/10.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBanksView.h"
@interface DZBanksView()<UIPickerViewDataSource,UIPickerViewDelegate>{
    
}
@property (nonatomic,strong) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (nonatomic,copy) NSString *currentBank;
@end
@implementation DZBanksView
-(void)replay:(NSArray *)banks{
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.dataSource = banks;
    self.currentBank = [banks firstObject];
    [self.picker reloadAllComponents];
}

#pragma mark--UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.dataSource.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.dataSource.count <= row) {
        return @"";
    }
    
    return self.dataSource[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.currentBank = self.dataSource[row];
}

//取消
- (IBAction)cancel:(id)sender {
    if (self.selectedBank) {
        self.selectedBank(nil);
    }
}

//确认
- (IBAction)should:(id)sender {
    if (self.selectedBank) {
        self.selectedBank(self.currentBank);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
