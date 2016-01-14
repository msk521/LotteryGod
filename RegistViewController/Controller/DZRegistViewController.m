//
//  DZRegistViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/15.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZRegistViewController.h"
#import "DZRegistRequest.h"
@interface DZRegistViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;
@property (weak, nonatomic) IBOutlet UITextField *validCode;
@property (weak, nonatomic) IBOutlet UIButton *validcodeButton;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int timeCound;
//验证码
@property (nonatomic,copy) NSString *valiCode;
@end

@implementation DZRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userName.layer.cornerRadius = 5.0f;
    self.userName.layer.masksToBounds = YES;
    self.password.layer.cornerRadius = 5.0f;
    self.password.layer.masksToBounds = YES;
    self.passwordAgain.layer.cornerRadius = 5.0f;
    self.passwordAgain.layer.masksToBounds = YES;
    self.validCode.layer.cornerRadius = 5.0f;
    self.validCode.layer.masksToBounds = YES;
}

//隐藏键盘
- (IBAction)hiddenKeyBoard:(id)sender {
    [self.view endEditing:YES];
}

//隐藏注册页
- (IBAction)hiddenCurrentView:(id)sender {
    if (self.hiddenView) {
        self.hiddenView(self.userName.text);
    }
}

//设置获取验证码的状态
-(void)resetButtonState{
    self.timeCound --;
    [self.validcodeButton setTitle:[NSString stringWithFormat:@"%d后可重发",self.timeCound] forState:UIControlStateDisabled];
    if (self.timeCound == 0) {
        [self.timer fire];
        if (self.timer != nil && [self.timer isValid]) {
            [self.timer invalidate];
        }
        self.timer = nil;
        self.validcodeButton.enabled = YES;
    [self.validcodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

//获取验证码
- (IBAction)valideCode:(id)sender {
    NSString *phoneRegex = @"1[3|4|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if (![phoneTest evaluateWithObject:self.userName.text]) {
        [DZUtile showAlertViewWithMessage:@"请输入正确的手机号码"];
        return;
    }
    self.timeCound = 60;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetButtonState) userInfo:nil repeats:YES];
        self.validcodeButton.enabled = NO;
    }
    
    DZBaseRequestModel *baseRequest = [[DZBaseRequestModel alloc] init];
    baseRequest.requestApi = [DZAllCommon shareInstance].allServiceRespond.sendVerificationCode;
    baseRequest.mobile = self.userName.text;
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

//注册
- (IBAction)registAction:(id)sender {
    NSString *woring = @"";
    
    NSString *phoneRegex = @"1[3|4|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    if (![phoneTest evaluateWithObject:self.userName.text]) {
        woring = @"请输入正确的手机号码";
    }else if (self.password.text.length == 0){
        woring = @"请输入密码";
    }else if (self.passwordAgain.text.length == 0){
        woring = @"请再次确认密码";
    }else if(self.validCode.text.length == 0){
        woring = @"请输入验证码";
    }else if (![self.passwordAgain.text isEqualToString:self.password.text]){
        woring = @"两次密码输入不一致";
    }else if (![self.validCode.text isEqualToString:self.valiCode]){
        //验证码不对
        woring = @"验证码输入错误";
    }
    
    if (woring.length > 0) {
        [DZUtile showAlertViewWithMessage:woring];
        return;
    }

    DZRegistRequest *registRequest = [[DZRegistRequest alloc] init];
    registRequest.requestApi = [DZAllCommon shareInstance].allServiceRespond.userRegist;
    registRequest.account = self.userName.text;
    registRequest.password = self.password.text;
    registRequest.password1 = self.passwordAgain.text;
    [self.hud show:YES];
    self.hud.labelText = @"正在注册...";
    [[DZRequest shareInstance] requestWithParamter:registRequest requestFinish:^(NSDictionary *result) {
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"注册成功";
        [self.hud hide:YES afterDelay:1.0f];
        [self performSelector:@selector(goBackToLogin) withObject:nil afterDelay:1.0f];
    } requestFaile:^(NSString *result) {
        [self.hud hide:YES];
    }];
}

-(void)goBackToLogin{
    if (self.hiddenView) {
        self.hiddenView(self.userName.text);
    }
}

//用户注册协议
- (IBAction)lookRegis:(id)sender {
    
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
