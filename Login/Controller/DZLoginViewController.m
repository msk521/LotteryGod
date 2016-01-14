//
//  DZLoginViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/3.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZLoginViewController.h"
#import "DZRegistViewController.h"
#import "DZForgetPasswordViewController.h"
#import "DZLoginRequest.h"
#import "DZUserInfoMation.h"
@interface DZLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordField;
@property (nonatomic,strong) DZRegistViewController *registController;
@property (nonatomic,strong) DZForgetPasswordViewController *forgetController;
@end

@implementation DZLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//取消登录
- (IBAction)cancelLogin:(id)sender {
    if (self.loginCancel) {
        self.loginCancel();
    }
}

//登录
- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    NSString *woring = @"";
    if (self.userNameField.text.length == 0) {
        woring = @"请输入用户名";
    }else if ( self.userPasswordField.text.length == 0){
        woring = @"请输入密码";
    }
    if (woring.length > 0) {
        [DZUtile showAlertViewWithMessage:woring];
        return;
    }
    [self.hud show:YES];
    self.hud.labelText = @"正在登录...";
    DZLoginRequest *registRequest = [[DZLoginRequest alloc] init];
    registRequest.account = self.userNameField.text;
    registRequest.password = self.userPasswordField.text;
    [[DZRequest shareInstance] requestWithParamter:registRequest requestFinish:^(NSDictionary *result) {
        if (result[@"result"]) {
            
            DZUserInfoMation *userInfoMation = [[DZUserInfoMation alloc] initWithDic:result[@"result"]];
            userInfoMation.password = self.userPasswordField.text;
            [DZAllCommon shareInstance].userInfoMation = userInfoMation;
            
            NSUserDefaults *defaulters = [NSUserDefaults standardUserDefaults];
            if (userInfoMation) {
                NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:userInfoMation];
                [defaulters setObject:data forKey:@"UserInfo"];
            }
            [defaulters synchronize];
  
        }
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"登录成功";
        [self.hud hide:YES afterDelay:1.0f];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserBlance object:nil];
        [self performSelector:@selector(goToFP) withObject:nil afterDelay:1.0f];
    } requestFaile:^(NSString *result) {
        [self.hud hide:YES];
    }];
}

-(void)goToFP{
    [self.view endEditing:YES];
    if (self.loginCancel) {
        self.loginCancel();
    }
}

//忘记密码
- (IBAction)frgetPassword:(UIButton *)sender {
    
}

//隐藏键盘
- (IBAction)hiddenKeyBoard:(id)sender {
    [self.view endEditing:YES];
}

//注册
- (IBAction)regisAccount:(id)sender {
    __weak DZLoginViewController *main = self;
    self.registController = [self.storyboard instantiateViewControllerWithIdentifier:@"DZRegistViewController"];
    self.registController.hiddenView = ^(NSString *userPhone){
       __block  CGRect rect = main.view.bounds;
        if (userPhone) {
            main.userNameField.text = userPhone;
        }
        [UIView animateWithDuration:0.3f animations:^{
            rect.origin.x = rect.size.width;
            main.registController.view.frame = rect;
        } completion:^(BOOL finished) {
            [main.registController.view removeFromSuperview];
            main.registController = nil;
        }];
    };
    
    __block CGRect rect = self.view.bounds;
    rect.origin.x = rect.size.width;
    self.registController.view.frame = rect;
    [self.view addSubview:self.registController.view];
    [UIView animateWithDuration:0.3f animations:^{
        rect.origin.x = 0;
        self.registController.view.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}

//忘记密码
- (IBAction)forGetPassword:(id)sender {
    __weak DZLoginViewController *main = self;
    self.forgetController = [self.storyboard instantiateViewControllerWithIdentifier:@"DZForgetPasswordViewController"];
    self.forgetController.hiddenView = ^(NSString *userPhone){
        __block  CGRect rect = main.view.bounds;
        if (userPhone) {
            main.userNameField.text = userPhone;
        }
        [UIView animateWithDuration:0.3f animations:^{
            rect.origin.x = rect.size.width;
            main.forgetController.view.frame = rect;
        } completion:^(BOOL finished) {
            [main.forgetController.view removeFromSuperview];
            main.forgetController = nil;
        }];
    };
    
    __block CGRect rect = self.view.bounds;
    rect.origin.x = rect.size.width;
    self.forgetController.view.frame = rect;
    [self.view addSubview:self.forgetController.view];
    [UIView animateWithDuration:0.3f animations:^{
        rect.origin.x = 0;
        self.forgetController.view.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
    
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
