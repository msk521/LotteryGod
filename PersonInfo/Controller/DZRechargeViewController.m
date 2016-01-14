//
//  DZRechargeViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/30.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZRechargeViewController.h"
#import "DZUserBalaceRequest.h"
#import "DZCharge.h"
#import <Pingpp.h>
@interface DZRechargeViewController ()<UIActionSheetDelegate>{
    UIActionSheet *channelActionSheet;
    NSString *channel;
    __weak IBOutlet UITextField *moneyText;
}
@property (nonatomic,copy) NSString *money;
@end

@implementation DZRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(IBAction)payMoney:(id)sender{
    [self.view endEditing:YES];
    if (!moneyText.text || moneyText.text.length == 0) {
        [DZUtile showAlertViewWithMessage:@"请输入金额"];
        return;
    }
    self.money = moneyText.text;
    channelActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"支付宝" otherButtonTitles:nil, nil];
    channelActionSheet.delegate = self;
    channelActionSheet.tag = 100;
    [channelActionSheet showInView:self.view];
}

//支付结果
-(void)payResult:(NSNotification *)notiy{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:PayResult object:nil];
    NSString *result = notiy.object;
    if ([result isEqualToString:@"success"]) {
        [self requestUserBalance];
        [DZUtile showAlertViewWithMessage:@"充值成功"];
    } else if([result isEqualToString:@"cancel"]) {
        // 支付失败或取消
        [DZUtile showAlertViewWithMessage:@"充值取消"];
    }else {
        [DZUtile showAlertViewWithMessage:@"充值失败"];
    }
}

//获取用户金币数
-(void)requestUserBalance{
    DZUserBalaceRequest *request = [[DZUserBalaceRequest alloc] init];
    [[DZRequest shareInstance] requestWithParamter:request requestFinish:^(NSDictionary *result) {
       
        if (result[@"result"] && [result[@"success"] intValue] != 0) {
            NSDictionary *resultDic = result[@"result"];
            DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
            userInfoMation.balance = resultDic[@"balance"];
            userInfoMation.score = resultDic[@"score"];
            [DZUtile saveData];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserBlance object:nil];
        }
    } requestFaile:^(NSString *result) {
        
    }];
}

#pragma mark---UIActionDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

        if (buttonIndex == 0) {
            channel = @"alipay";
        } else{
            return;
        }

//    if (buttonIndex == 0) {
//        channel = @"wx";
//    } else if (buttonIndex == 1) {
//        channel = @"alipay";
//    } else{
//        return;
//    }
    //else if (buttonIndex == 2) {
//    channel = @"upacp";
//}
    [self payAction:channel];
}

-(void)payAction:(NSString *)channelValue{
    
    DZCharge *baseRequest = [[DZCharge alloc] init];
    baseRequest.requestApi = PAYMONEYURL;
    baseRequest.amount = [NSString stringWithFormat:@"%.2f",[self.money floatValue]];
    baseRequest.account = [DZAllCommon shareInstance].userInfoMation.account;
    baseRequest.channel = channelValue;
    [[DZRequest shareInstance] requestWithParamter:baseRequest requestFinish:^(NSDictionary *result) {
        NSData* data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
        NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self payWithData:bodyData];
        
    } requestFaile:^(NSString *result) {
        
    }];
}

-(void)payWithData:(NSString *)charge{
    __weak DZRechargeViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
            NSLog(@"completion block: %@", result);
            
            if ([result isEqualToString:@"success"]) {
                // 支付成功
                 DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
                userInfoMation.balance = [NSString stringWithFormat:@"%.2f",[userInfoMation.balance floatValue] + self.money.floatValue];
                [DZUtile saveData];
                [DZUtile showAlertViewWithMessage:@"充值成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserBlance object:nil];
            } else if([result isEqualToString:@"cancel"]) {
                // 支付失败或取消
                [DZUtile showAlertViewWithMessage:@"充值取消"];
            }else {
                [DZUtile showAlertViewWithMessage:@"充值失败"];
            }
            
            if (error == nil) {
                NSLog(@"PingppError is nil");
            } else {
                NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
            }
        }];
    });
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
