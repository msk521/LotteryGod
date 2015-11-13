//
//  DZLookResultViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/23.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZLookResultViewController.h"
#import "DZShouldBuyViewController.h"
#import "DZCharge.h"
#import <Pingpp.h>
@interface DZLookResultViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
    UIActionSheet  *channelActionSheet;
}
//共多少注
@property (weak, nonatomic) IBOutlet UILabel *totalCount;
//共多少钱
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;

@end

@implementation DZLookResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalCount.text = [NSString stringWithFormat:@"共%d注",(int)self.searchResultArr.count];
    self.totalMoney.text = [NSString stringWithFormat:@"%d元",(int)self.searchResultArr.count*2];
}

//购买
- (IBAction)buyAction:(UIButton *)sender {

    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
        if (!userInfoMation.account || userInfoMation.account.length == 0) {
            DZLoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"DZLoginViewController"];
            [DZUtile showLoginViewController:loginView animation:YES finishLoading:^{
                
            }hiddenFinish:^{
                
            }];
        }else{
            
            DZShouldBuyViewController *shouldBuy = [self.storyboard instantiateViewControllerWithIdentifier:@"DZShouldBuyViewController"];
            shouldBuy.money = [NSString stringWithFormat:@"%d",[self.totalMoney.text intValue]];
            shouldBuy.isLookResult = YES;
            shouldBuy.totalCount = [NSString stringWithFormat:@"%d",(int)self.searchResultArr.count];
            shouldBuy.selectedArr = self.searchResultArr;
            shouldBuy.howMoney = @"2";
            [self.navigationController pushViewController:shouldBuy animated:YES];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:PayResult object:nil];
//            
//            channelActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"微信" otherButtonTitles:@"支付宝",@"银联", nil];
//            channelActionSheet.delegate = self;
//            channelActionSheet.tag = 100;
//            [channelActionSheet showInView:self.view];
        }
}

//支付结果
-(void)payResult:(NSNotification *)notiy{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PayResult object:nil];
    NSString *result = notiy.object;
    if ([result isEqualToString:@"success"]) {
        // 支付成功
        [DZUtile showAlertViewWithMessage:@"支付成功"];
    } else if([result isEqualToString:@"cancel"]) {
        // 支付失败或取消
        [DZUtile showAlertViewWithMessage:@"支付取消"];
    }else {
        [DZUtile showAlertViewWithMessage:@"支付失败"];
    }
}

#pragma mark---UIActionDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *channel;
    if (actionSheet.tag == 100) {
        if (buttonIndex == 0) {
            channel = @"wx";
        } else if (buttonIndex == 1) {
            channel = @"alipay";
        } else if (buttonIndex == 2) {
            channel = @"upacp";
        }
        [self payAction:channel];
    }
}

-(void)payAction:(NSString *)channelValue{
    
    DZCharge *baseRequest = [[DZCharge alloc] init];
    baseRequest.requestApi = PAYMONEYURL;
    baseRequest.amount = [NSString stringWithFormat:@"%d",[self.totalMoney.text intValue]];
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
    __weak DZLookResultViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
            NSLog(@"completion block: %@", result);
            
            if ([result isEqualToString:@"success"]) {
                // 支付成功
                [DZUtile showAlertViewWithMessage:@"支付成功"];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ballCell" forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *result = self.searchResultArr[indexPath.row];
            NSArray *resultArr = [result componentsSeparatedByString:@","];
            // 处理耗时操作的代码块...
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:100];
            UIImageView *imageView1 = (UIImageView *)[cell.contentView viewWithTag:101];
            UIImageView *imageView2 = (UIImageView *)[cell.contentView viewWithTag:102];
            UIImageView *imageView3 = (UIImageView *)[cell.contentView viewWithTag:103];
            UIImageView *imageView4 = (UIImageView *)[cell.contentView viewWithTag:104];
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[resultArr[0] intValue]]];
                imageView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[resultArr[1] intValue]]];
                imageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[resultArr[2] intValue]]];
                imageView3.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[resultArr[3] intValue]]];
                imageView4.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[resultArr[4] intValue]]];
            });
        });
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.0f;
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
