//
//  DZPersonInfoViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/13.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZPersonInfoViewController.h"
#import "DZPersonInfoTableViewCell.h"
#import "BIDDatePickerView.h"
#import "DZUpdateUserInfoRequest.h"
@interface DZPersonInfoViewController()<UIActionSheetDelegate>{
    //用户名
    __weak IBOutlet UITextField *userNameField;
    //手机号码
    __weak IBOutlet UITextField *mobileNumber;
    //用户性别
    __weak IBOutlet UITextField *userSex;
    UIActionSheet *actionSheet;
    BIDDatePickerView *datePicker;
    //生日
    __weak IBOutlet UITextField *qqField;
    __weak IBOutlet UITextField *emailField;
    int sexIntValue;
    //用户名
    __weak IBOutlet UILabel *userAccountField;
}

@property (weak, nonatomic) IBOutlet UITextField *brithdayField;
@end
@interface DZPersonInfoViewController ()<UITextFieldDelegate>

@end

@implementation DZPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sexIntValue = 0;
    userNameField.text =  [DZAllCommon shareInstance].userInfoMation.name;
    userSex.text = [DZAllCommon shareInstance].userInfoMation.sex;
    sexIntValue = [userSex.text isEqual:@"男"]?0:1;
    self.brithdayField.text = [DZAllCommon shareInstance].userInfoMation.birthday;
    qqField.text = [DZAllCommon shareInstance].userInfoMation.qq;
    emailField.text = [DZAllCommon shareInstance].userInfoMation.email;
    mobileNumber.text = [DZAllCommon shareInstance].userInfoMation.phone;
    userAccountField.text = [NSString stringWithFormat:@"账号:%@",[DZAllCommon shareInstance].userInfoMation.account];
}

//选择性别
- (IBAction)selectedSex:(UIButton *)sender {
    [self.view endEditing:YES];
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
    [actionSheet showInView:self.view];
}

//生日
- (IBAction)birthDay:(UIButton *)sender {
    [self.view endEditing:YES];
    self.datePicker.hidden = NO;
}

-(BIDDatePickerView *)datePicker{
    if (!datePicker) {
        __weak DZPersonInfoViewController *main = self;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        datePicker = [[[NSBundle mainBundle] loadNibNamed:@"BIDDatePickerView" owner:self options:nil] firstObject];
        
        datePicker.frame = CGRectMake(0, self.view.frame.size.height + self.view.frame.origin.y - datePicker.frame.size.height, self.view.frame.size.width, datePicker.frame.size.height);
        datePicker.datePicker.calendar = nil;
        datePicker.datePicker.timeZone = nil;
        datePicker.datePicker.datePickerMode = UIDatePickerModeDate;
        
        datePicker.selectedItem = ^(int type){
            main.datePicker.hidden = YES;
            if (type == 0) {
                return ;
            }
            if (datePicker.datePicker.datePickerMode == UIDatePickerModeDate) {
                main.brithdayField.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:main.datePicker.datePicker.date]];
            }
        };
        [self.view addSubview:datePicker];
    }
    return datePicker;
}

//修改个人资料
- (IBAction)updateUserInfo:(UIButton *)sender {
    DZUpdateUserInfoRequest *request = [[DZUpdateUserInfoRequest alloc] init];
    request.account = [DZAllCommon shareInstance].userInfoMation.account;
    request.idNumber = @"";
    request.name = userNameField.text;
    request.sex = sexIntValue;
    request.birthday = self.brithdayField.text;
    request.qq = qqField.text;
    request.email = emailField.text;
    request.phone =  mobileNumber.text;
    
    [[DZRequest shareInstance] requestWithParamter:request requestFinish:^(NSDictionary *result) {
        if ([result[@"success"] intValue] == 1) {
            [DZAllCommon shareInstance].userInfoMation.name = request.name;
            [DZAllCommon shareInstance].userInfoMation.sex = request.sex == 0? @"男":@"女";
            [DZAllCommon shareInstance].userInfoMation.birthday = request.birthday;
            [DZAllCommon shareInstance].userInfoMation.qq = request.qq;
            [DZAllCommon shareInstance].userInfoMation.email = request.email;
            [DZAllCommon shareInstance].userInfoMation.phone = request.phone;
            
            [self.hud show:YES];
            self.hud.labelText = @"修改成功";
            [self.hud hide:YES afterDelay:1.0f];
            [self performSelector:@selector(goBack:) withObject:nil afterDelay:1.0f];
        }else{
            [DZUtile showAlertViewWithMessage:result[@"errorMessage"]];
        }
    } requestFaile:^(NSString *result) {
        
    }];
}

- (IBAction)hiddenKeyboard:(UIButton *)sender {
    [self.view endEditing:YES];
}

#pragma mark--UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
      userSex.text = @"男";
        sexIntValue = 0;
    }else if(buttonIndex == 1){
      userSex.text = @"女";
        sexIntValue = 1;
    }
}

#pragma mark--UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
