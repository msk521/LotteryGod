//
//  DZForgetPasswordViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/12/3.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZForgetPasswordViewController.h"
#import "DZRegistRequest.h"
@interface DZForgetPasswordViewController ()
//账号
@property (weak, nonatomic) IBOutlet UITextField *userAccountFiled;
//密码
@property (weak, nonatomic) IBOutlet UITextField *nPasswordField;
//确认密码
@property (weak, nonatomic) IBOutlet UITextField *againPasswordField;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *valiCodeField;
@property (nonatomic,copy) NSString *valiCode;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int timeCound;
@property (weak, nonatomic) IBOutlet UIButton *valicodeButton;

@end

@implementation DZForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//设置获取验证码的状态
-(void)resetButtonState{
    self.timeCound --;
    [self.valicodeButton setTitle:[NSString stringWithFormat:@"%d后可重发",self.timeCound] forState:UIControlStateDisabled];
    if (self.timeCound == 0) {
        [self.timer fire];
        if (self.timer != nil && [self.timer isValid]) {
            [self.timer invalidate];
        }
        self.timer = nil;
        self.valicodeButton.enabled = YES;
        [self.valicodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}


//获取验证码
- (IBAction)valideCode:(id)sender {
    NSString *phoneRegex = @"1[3|4|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if (![phoneTest evaluateWithObject:self.userAccountFiled.text]) {
        [DZUtile showAlertViewWithMessage:@"请输入正确的手机号码"];
        return;
    }
    self.timeCound = 60;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetButtonState) userInfo:nil repeats:YES];
        self.valicodeButton.enabled = NO;
    }
    
    DZBaseRequestModel *baseRequest = [[DZBaseRequestModel alloc] init];
    baseRequest.requestApi = [DZAllCommon shareInstance].allServiceRespond.sendVerificationCode;
    baseRequest.mobile = self.userAccountFiled.text;
    [[DZRequest shareInstance] requestWithParamter:baseRequest requestFinish:^(NSDictionary *result) {
        if ([result[@"success"] intValue] == 1) {
            self.valiCode = result[@"result"];
        }else{
            [DZUtile showAlertViewWithMessage:@"验证码发送失败!"];
        }
    } requestFaile:^(NSString *result) {
        [self.hud hide:YES];
    }];
}

//确认修改
- (IBAction)shouldUpdate:(id)sender {
    [self.view endEditing:YES];
    NSString *woring = @"";
    NSString *phoneRegex = @"1[3|4|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    if (![phoneTest evaluateWithObject:self.userAccountFiled.text]) {
        woring = @"请输入正确的手机号码";
    }else if (self.nPasswordField.text.length == 0){
        woring = @"请输入密码";
    }else if (self.againPasswordField.text.length == 0){
        woring = @"请再次确认密码";
    }else if(self.valiCodeField.text.length == 0){
        woring = @"请输入验证码";
    }else if (![self.nPasswordField.text isEqualToString:self.againPasswordField.text]){
        woring = @"两次密码输入不一致";
    }else if (![self.valiCodeField.text isEqualToString:self.valiCode]){
        //验证码不对
        woring = @"验证码输入错误";
    }
    
    if (woring.length > 0) {
        [DZUtile showAlertViewWithMessage:woring];
        return;
    }
    
    DZRegistRequest *registRequest = [[DZRegistRequest alloc] init];
    registRequest.requestApi = [DZAllCommon shareInstance].allServiceRespond.userForgetPassword;
    registRequest.account = self.userAccountFiled.text;
    registRequest.password = self.nPasswordField.text;
    registRequest.password1 = self.againPasswordField.text;
    [self.hud show:YES];
    self.hud.labelText = @"请稍后...";
    [[DZRequest shareInstance] requestWithParamter:registRequest requestFinish:^(NSDictionary *result) {
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"重置成功成功";
        [self.hud hide:YES afterDelay:1.0f];
        [self performSelector:@selector(goBackToLogin) withObject:nil afterDelay:1.0f];
    } requestFaile:^(NSString *result) {
        [self.hud hide:YES];
    }];
}

-(void)goBackToLogin{
    if (self.hiddenView) {
        self.hiddenView(self.userAccountFiled.text);
    }
}

//隐藏
- (IBAction)hiddenCurrentView:(id)sender {
    if (self.hiddenView) {
        self.hiddenView(self.userAccountFiled.text);
    }
}

//隐藏键盘
- (IBAction)hiddenKeyBoard:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark---UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
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
