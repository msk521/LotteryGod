//
//  DZGetMoneyViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/10.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZGetMoneyViewController.h"
#import "DZGetMoneyRequest.h"
#import "DZBanksView.h"
@interface DZGetMoneyViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *aboutGetMoney;
@property (weak, nonatomic) IBOutlet UITextField *bankNumber;
@property (weak, nonatomic) IBOutlet UITextField *moenyField;
//剩余金额
@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;
//持卡人姓名
@property (weak, nonatomic) IBOutlet UITextField *bankCardUserName;
//选择银行
@property (weak, nonatomic) IBOutlet UIButton *selectedBankKind;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) DZBanksView *banksView;
@end

@implementation DZGetMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.surplusLabel.text = [DZAllCommon shareInstance].userInfoMation.balance;
    self.dataSource = @[@"工商银行",@"农业银行",@"中国银行",@"建设银行",@"交通银行",@"华夏银行",@"光大银行",@"招商银行",@"中信银行",@"兴业银行",@"民生银行",@"深圳发展银行",@"广东发展银行",@"上海浦东发展银行",@"渤海银行",@"恒丰银行",@"浙商银行",@"中国邮政储蓄银行"];
    self.aboutGetMoney.text = @"提现规则:\n提现时间:每周一到周五,9:30-17:00实时处理，周六周日提现顺延至下一个工作日进行处理\n到帐时间:\n提现时间内提现审核通过后，24小时之内到账\n提现限额:单笔提现最小限额10元，最大限额10000元\n提示:充值后24小时内不支持提现，为防止他人盗刷银行卡";
}

//选择银行
- (IBAction)showBanks:(UIButton *)sender {
    [self.view endEditing:YES];
    if (!self.banksView) {
        __weak DZGetMoneyViewController *main = self;
        self.banksView = [[[NSBundle mainBundle] loadNibNamed:@"DZBanksView" owner:self options:nil] firstObject];
        [self.banksView replay:self.dataSource];
        self.banksView.selectedBank = ^(NSString *bank){
            if (bank == nil) {
                [main hiddenView];
            }else{
                [main.selectedBankKind setTitle:bank forState:UIControlStateNormal];
                [main hiddenView];
            }
        };
        self.banksView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.banksView.frame.size.height);
        self.banksView.hidden = YES;
        [self.view addSubview:self.banksView];
    }
    
    if (self.banksView.hidden) {
        [self showVoew];
    }else{
        [self hiddenView];
    }
}

-(void)showVoew{
    self.banksView.hidden = NO;
    [UIView animateWithDuration:0.3f animations:^{
        self.banksView.frame = CGRectMake(0, self.view.bounds.size.height-self.banksView.frame.size.height, self.view.bounds.size.width, self.banksView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hiddenView{
    [UIView animateWithDuration:0.3f animations:^{
        self.banksView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.banksView.frame.size.height);
    } completion:^(BOOL finished) {
        self.banksView.hidden = YES;
    }];
}

//申请
- (IBAction)applyMoney:(UIButton *)sender {
    [self.view endEditing:YES];
    [self hiddenView];
    NSString *woring = @"";
    if ([[self.selectedBankKind titleForState:UIControlStateNormal] isEqualToString:@"选择银行"]) {
        woring = @"请选择银行";
    }else if(self.bankCardUserName.text.length == 0){
        woring = @"请输入持卡人姓名";
    }else if (self.bankNumber.text.length == 0) {
        woring = @"请输入银行卡号";
    }else if (self.moenyField.text.intValue < 10) {
        woring = @"最小提现金额为10元";
    }else if (self.surplusLabel.text.intValue < self.moenyField.text.intValue){
        woring = @"余额不足";
    }else if (self.moenyField.text.intValue > 10000){
        woring = @"单笔提现最大金额不能超过10000元";
    }
    
    if (woring.length > 0) {
        [DZUtile showAlertViewWithMessage:woring];
        return;
    }
    
    DZGetMoneyRequest *moneyRequest = [[DZGetMoneyRequest alloc] init];
    moneyRequest.bankName = [self.selectedBankKind titleForState:UIControlStateNormal];
    moneyRequest.bankRegisteredName = self.bankCardUserName.text;
    moneyRequest.amount = self.moenyField.text;
    moneyRequest.bankCardNumber = self.bankNumber.text;
    [[DZRequest shareInstance] requestWithParamter:moneyRequest requestFinish:^(NSDictionary *result) {
        if ([result[@"success"] intValue] == 1) {
            [DZUtile showAlertViewWithMessage:result[@"result"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [DZUtile showAlertViewWithMessage:result[@"errorMessage"]];
        }
    } requestFaile:^(NSString *error) {
        
    }];
}

//隐藏键盘
- (IBAction)hiddenKeyBoard:(UIButton *)sender {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
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
