//
//  DZUpdateUserPasswordViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/9.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZUpdateUserPasswordViewController.h"
#import "DZUpdatePasswordRequest.h"
@interface DZUpdateUserPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *againPassword;
@property (weak, nonatomic) IBOutlet UITextField *nPassword;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;

@end

@implementation DZUpdateUserPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


//确认修改
- (IBAction)shouldUpdate:(UIButton *)sender {
    NSString *woring = @"";
    if (self.oldPasswordField.text.length == 0) {
        woring = @"请输入原密码";
    }else if (self.nPassword.text.length == 0){
        woring = @"请输入新密码";
    }else if (self.againPassword.text.length == 0){
        woring = @"请再次输入密码";
    }
    
    if (woring.length > 0) {
        [DZUtile showAlertViewWithMessage:woring];
        return;
    }
    DZUpdatePasswordRequest *request = [[DZUpdatePasswordRequest alloc] init];
    request.password = self.oldPasswordField.text;
    request.password1 = self.nPassword.text;
    request.password2 = self.againPassword.text;
    [[DZRequest shareInstance] requestWithParamter:request requestFinish:^(NSDictionary *respondDic) {
        if ([respondDic[@"success"] intValue] == 1) {
            [DZUtile showAlertViewWithMessage:@"修改密码成功"];
        }else{
            [DZUtile showAlertViewWithMessage:respondDic[@"errorMessage"]];
        }
    } requestFaile:^(NSString *error) {
        
    }];
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
