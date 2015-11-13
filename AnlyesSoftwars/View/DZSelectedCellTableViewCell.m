//
//  DZSelectedCellTableViewCell.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/22.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZSelectedCellTableViewCell.h"
@interface DZSelectedCellTableViewCell(){
    
    __weak IBOutlet UILabel *selectedName;
    __weak IBOutlet UIButton *checkButton;
    DZAnlyesSelectedRespond *currentRespond;
}
@end
@implementation DZSelectedCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)repaly:(DZAnlyesSelectedRespond *)respond{
    currentRespond = respond;
    checkButton.selected = currentRespond.selected;
    selectedName.text = [NSString stringWithFormat:@"%@: %@",respond.selectedName,respond.commintValue];
    if (respond.ltfwValue && respond.ltfwValue.length > 0) {
        selectedName.text = [NSString stringWithFormat:@"%@: %@",respond.selectedName,respond.ltfwValue];
    }
    
    if (respond.phzsValue && respond.phzsValue.length > 0){
        selectedName.text = [NSString stringWithFormat:@"%@: %@",respond.selectedName,respond.phzsValue];
 
    }
    
    if (respond.lhgjValue && respond.lhgjValue.length > 0){
        selectedName.text = [NSString stringWithFormat:@"%@: %@",respond.selectedName,respond.lhgjValue];
    }
    
    if (respond.danmaValue && respond.danmaValue.length > 0) {
        selectedName.text = [NSString stringWithFormat:@"%@: %@",respond.selectedName,respond.danmaValue];
    }
}

//选择
- (IBAction)checkAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    currentRespond.selected = !currentRespond.selected;
}

//删除
- (IBAction)deleteAction:(id)sender {
    if (self.deleteData) {
        self.deleteData();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
