//
//  PersonInfoViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/3.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "DZPersonInfoViewController.h"
#import "DZRechargeViewController.h"
#import "DZMyOrderListViewController.h"
#import "DZUpdateUserPasswordViewController.h"
#import "DZGetMoneyViewController.h"
#import "DZGetMoneyRecordViewController.h"
typedef enum {
    UserTopGroup_UserInfo,
    UserOtherGroup_Password,
//    UserTopGroup_MessageCenter,
    UserTopGroup_Count
}UserTopGroup;

typedef enum {
    UserOtherGroup_Money,
    UserOtherGroup_GetMoney,
    UserOtherGroup_GetMoneyRecord,
//    UserOtherGroup_UserNum,
//    UserOtherGroup_BankNum,
    
    UserOtherGroup_Count
}UserOtherGroup;

@interface PersonInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return  UserTopGroup_Count;
    }else if (section == 1){
        return UserOtherGroup_Count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case UserTopGroup_UserInfo:
                //个人资料
                cell.textLabel.text = @"个人资料";
                break;
//            case UserTopGroup_MessageCenter:
//                //消息中心
//                cell.textLabel.text = @"消息中心";
//                break;
            case UserOtherGroup_Password:
                //密码
                cell.textLabel.text = @"登录密码";
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case UserOtherGroup_Money:
                //充值
                cell.textLabel.text = @"充值";
                break;
            case UserOtherGroup_GetMoney:
                //提现
                cell.textLabel.text = @"提现";
                break;
            case UserOtherGroup_GetMoneyRecord:
                //提现纪录
            {
               cell.textLabel.text = @"提现记录";
            }
                break;
//            case UserOtherGroup_BankNum:
//                //银行卡
//                cell.textLabel.text = @"银行卡";
//                break;

            default:
                break;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case UserTopGroup_UserInfo:
                //个人资料
            {
                DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
                if (!userInfoMation.account || userInfoMation.account.length == 0) {
                    DZLoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"DZLoginViewController"];
                    [DZUtile showLoginViewController:loginView animation:YES finishLoading:^{
                        DZPersonInfoViewController *personInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"DZPersonInfoViewController"];
                        [self.navigationController pushViewController:personInfo animated:YES];
                    
                    }hiddenFinish:^{
                        
                    }];
                }else{

                DZPersonInfoViewController *personInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"DZPersonInfoViewController"];
                    [self.navigationController pushViewController:personInfo animated:YES];
                }
            }
                break;
            case UserOtherGroup_Password:
                //密码
            {
                DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
                if (!userInfoMation.account || userInfoMation.account.length == 0) {
                    DZLoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"DZLoginViewController"];
                    [DZUtile showLoginViewController:loginView animation:YES finishLoading:^{
                        DZUpdateUserPasswordViewController *personInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"DZUpdateUserPasswordViewController"];
                        [self.navigationController pushViewController:personInfo animated:YES];
                        
                    }hiddenFinish:^{
                        
                    }];
                }else{
                    
                    DZUpdateUserPasswordViewController *personInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"DZUpdateUserPasswordViewController"];
                    [self.navigationController pushViewController:personInfo animated:YES];
                }
        }
                
                break;
//            case UserTopGroup_MessageCenter:
//                //消息中心
//                
//                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case UserOtherGroup_Money:
                //充值
            {
                DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
                if (!userInfoMation.account || userInfoMation.account.length == 0) {
                    DZLoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"DZLoginViewController"];
                    [DZUtile showLoginViewController:loginView animation:YES finishLoading:^{
                        DZRechargeViewController *charge = [self.storyboard instantiateViewControllerWithIdentifier:@"DZRechargeViewController"];
                        [self.navigationController pushViewController:charge animated:YES];
                    }hiddenFinish:^{
                        
                    }];
                }else{
                DZRechargeViewController *charge = [self.storyboard instantiateViewControllerWithIdentifier:@"DZRechargeViewController"];
                    [self.navigationController pushViewController:charge animated:YES];
                }
            }
                break;
            case UserOtherGroup_GetMoney:
                //提现
            {
                DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
                if (!userInfoMation.account || userInfoMation.account.length == 0) {
                    DZLoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"DZLoginViewController"];
                    [DZUtile showLoginViewController:loginView animation:YES finishLoading:^{
                        DZGetMoneyViewController *charge = [self.storyboard instantiateViewControllerWithIdentifier:@"DZGetMoneyViewController"];
                        [self.navigationController pushViewController:charge animated:YES];
                    }hiddenFinish:^{
                        
                    }];
                }else{
                    DZGetMoneyViewController *charge = [self.storyboard instantiateViewControllerWithIdentifier:@"DZGetMoneyViewController"];
                    [self.navigationController pushViewController:charge animated:YES];
                }
            }
                
                break;
            case UserOtherGroup_GetMoneyRecord:
            {

                DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
                if (!userInfoMation.account || userInfoMation.account.length == 0) {
                    DZLoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"DZLoginViewController"];
                    [DZUtile showLoginViewController:loginView animation:YES finishLoading:^{
                        DZGetMoneyRecordViewController *charge = [self.storyboard instantiateViewControllerWithIdentifier:@"DZGetMoneyRecordViewController"];
                        [self.navigationController pushViewController:charge animated:YES];
                    }hiddenFinish:^{
                        
                    }];
                }else{
                    DZGetMoneyRecordViewController *charge = [self.storyboard instantiateViewControllerWithIdentifier:@"DZGetMoneyRecordViewController"];
                    [self.navigationController pushViewController:charge animated:YES];
                }
                
            }
                break;
//            case UserOtherGroup_BankNum:
//                //银行卡
//
//                break;
;
            default:
                break;
        }
    }
}

//登出
- (IBAction)loginOurt:(UIButton *)sender {
    NSUserDefaults *defaulters = [NSUserDefaults standardUserDefaults];
    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
    if (userInfoMation) {
        [defaulters removeObjectForKey:@"UserInfo"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [DZUtile showAlertViewWithMessage:@"您还未登录"];
        return;
    }
    [defaulters synchronize];
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
