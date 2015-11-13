//
//  DZPersonInfoTableViewCell.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/13.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZPersonInfoTableViewCell.h"
@interface DZPersonInfoTableViewCell()<UITextFieldDelegate>{
    
    __weak IBOutlet UITextField *rightInputField;
    __weak IBOutlet UILabel *leftName;
}
@end
@implementation DZPersonInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)replay:(NSString *)name planceName:(NSString *)planceName indexPath:(NSIndexPath *)indexPath{
    leftName.text = name;
    rightInputField.placeholder = planceName;
    rightInputField.delegate = self;
    
    switch (indexPath.row) {
        
        case UserInfo_phoneNumber:
        {
            
        }
            break;
        case UserInfo_sex:
        {
            
        }
            break;
        case UserInfo_QQ:
        {
        }
            break;
        case UserInfo_mail:
        {
        }
            break;
        case UserInfo_birthDay:
        {
        }
            break;
        default:
            break;
    }
    
}

#pragma mark--UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
