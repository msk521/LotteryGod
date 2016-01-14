//
//  DZPayMoneyViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/20.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZPayMoneyViewController.h"
#import "DZBuySuccessViewController.h"
#import "DZUserBalaceRequest.h"
#import "DZCharge.h"
#import <Pingpp.h>
#import "AppDelegate.h"
@interface DZPayMoneyViewController ()<UIActionSheetDelegate>{
    //支付方式
    NSString *channel;
}
//当前彩种
@property (weak, nonatomic) IBOutlet UILabel *currentKindName;
//当前期数
@property (weak, nonatomic) IBOutlet UILabel *currentPoids;
//应付金额
@property (weak, nonatomic) IBOutlet UILabel *shouldPayMoneyLabel;
//购买情况
@property (weak, nonatomic) IBOutlet UILabel *buyInfoLabel;
//我的余额
@property (weak, nonatomic) IBOutlet UILabel *mybalance;
@property (weak, nonatomic) IBOutlet UIButton *shoudPayButton;

@end

@implementation DZPayMoneyViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *balanceStr = [NSString stringWithFormat:@"%@元",[DZAllCommon shareInstance].userInfoMation.balance];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:balanceStr];
    UIColor *color = [UIColor blackColor];
    
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   color,NSForegroundColorAttributeName,nil];
    [attributedStr addAttributes:attributeDict range:NSMakeRange(balanceStr.length-1,1)];
    self.mybalance.attributedText = attributedStr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *shouldPayMoneyStr = [NSString stringWithFormat:@"%.2f元",[self.shouldPayMoney floatValue]];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:shouldPayMoneyStr];
    UIColor *color = [UIColor blackColor];
    
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   color,NSForegroundColorAttributeName,nil];
    [attributedStr addAttributes:attributeDict range:NSMakeRange(shouldPayMoneyStr.length-1,1)];
    self.shouldPayMoneyLabel.attributedText = attributedStr;
    self.currentKindName.text = [DZAllCommon shareInstance].currentLottyKind.name;
    self.buyInfoLabel.text = self.buyInfo;
    self.currentPoids.text = self.currentPoidPayMoney;
}

//确认付款
- (IBAction)payMoney:(UIButton *)sender {
//    NSString *myBalanceStr = [DZAllCommon shareInstance].userInfoMation.balance;
//    NSString *balance = [myBalanceStr stringByReplacingOccurrencesOfString:@"," withString:@""];
//    if (balance.floatValue < [self.shouldPayMoney floatValue]) {
//        [self payMoney];
//       
//        return;
//    }
    [self shoudlPayMoneyBuyCP:sender];
}
/**
 *  购买彩票
 *
 *  @param sender
 */
-(void)shoudlPayMoneyBuyCP:(UIButton *)sender{
    sender.enabled = NO;
    self.hud.labelText = @"正在投注...";
    [self.hud show:YES];
    [[DZRequest shareInstance] requestWithPDictionaryaramter:self.commitDic requestFinish:^(NSDictionary *result) {
        NSLog(@"result:%@",result);
        [self.hud hide:YES];
        sender.enabled = YES;
        if ([result[@"success"] intValue] == 1) {
            AppDelegate *main = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [main.selectedAnlyes removeAllObjects];
            
            NSDictionary *resultDic = result[@"result"];
            DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
            userInfoMation.balance = resultDic[@"balance"];
            userInfoMation.score = resultDic[@"score"];
            [DZUtile saveData];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserBlance object:nil];
            
            DZBuySuccessViewController *successController = [self.storyboard instantiateViewControllerWithIdentifier:@"DZBuySuccessViewController"];
            [self.navigationController pushViewController:successController animated:YES];
        }else{
            [self.hud hide:YES];
            [DZUtile showAlertViewWithMessage:result[@"errorMessage"]];
        }
        
    } requestFaile:^(NSString *error) {
        [self.hud hide:YES];
    }];
}


//从支付宝付款
-(void)payMoney{
    [self.view endEditing:YES];
   UIActionSheet *channelActionSheet = [[UIActionSheet alloc] initWithTitle:@"您的余额不足请选择其他支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"支付宝" otherButtonTitles:nil, nil];
    channelActionSheet.delegate = self;
    channelActionSheet.tag = 100;
    [channelActionSheet showInView:self.view];
}

//支付结果
-(void)payResult:(NSNotification *)notiy{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PayResult object:nil];
    NSString *result = notiy.object;
    if ([result isEqualToString:@"success"]) {
        //支付成功
        [self shoudlPayMoneyBuyCP:self.shoudPayButton];
    } else if([result isEqualToString:@"cancel"]) {
        // 支付失败或取消
        [DZUtile showAlertViewWithMessage:@"支付取消"];
    }else {
        [DZUtile showAlertViewWithMessage:@"支付失败"];
    }
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
    NSString *shoudPay = [NSString stringWithFormat:@"%.2f",[self.shouldPayMoney floatValue]];
    DZCharge *baseRequest = [[DZCharge alloc] init];
    baseRequest.requestApi = PAYMONEYURL;
    baseRequest.amount = shoudPay;
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
    __weak DZPayMoneyViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
            NSLog(@"completion block: %@", result);
            
            if ([result isEqualToString:@"success"]) {
                // 支付成功
                [self shoudlPayMoneyBuyCP:weakSelf.shoudPayButton];
                
            } else if([result isEqualToString:@"cancel"]) {
                // 支付失败或取消
                [DZUtile showAlertViewWithMessage:@"支付取消"];
            }else {
                [DZUtile showAlertViewWithMessage:@"支付失败"];
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
