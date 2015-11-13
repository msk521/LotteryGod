//
//  DZSeniorChaseNumberViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/28.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZSeniorChaseNumberViewController.h"
#import "DZPoidsQueryRequest.h"
#import "DZCharge.h"
#import "DZBuySuccessViewController.h"
#import <Pingpp.h>
#define ZXYL @"最小盈利"
#define GDBL @"固定倍率"
@interface DZSeniorChaseNumberViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>{
    UIButton *currentBtn;
    UIActionSheet *parentSheet;
    //每注中奖金额
    float profit;
    //每注多少钱
    float principal;
    UIActionSheet *channelActionSheet;
    NSString *channel;
    //追号计划生成的投注倍数
    NSString *tzBeishu;
    //是否停止追号当中奖时 默认1 0是不停止
    NSString *isStopWhenWin;
    __weak IBOutlet UILabel *buyInfoLabel;
    NSString *currentRequestApi;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *dataSource;
//切换最小盈利和固定倍率
@property (weak, nonatomic) IBOutlet UIButton *changeYLORBL;
//倍率 或 最小盈利
@property (weak, nonatomic) IBOutlet UIButton *rateButton;

@end

@implementation DZSeniorChaseNumberViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    isStopWhenWin = @"1";
    //固定倍率
    currentRequestApi = FixedRateLotteryChasePlanGenerator;
    NSDictionary *playDic = [[DZAllCommon shareInstance].currentLottyKind.plays lastObject];
    //中奖金额
    profit = [playDic[@"principal"] floatValue];
    principal = [playDic[@"profit"] floatValue];
   buyInfoLabel.text = [NSString stringWithFormat:@"共%d注，%.2f元",self.totalCount,self.totalCount * profit * self.parent.floatValue];
    [self requestGaoJiZhuiHao];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

//追号
-(void)requestGaoJiZhuiHao{
    [self.dataSource removeAllObjects];
    NSDictionary *params = @{@"profit":[NSString stringWithFormat:@"%.2f",principal * self.parent.floatValue],@"principal":[NSString stringWithFormat:@"%.2f",profit * self.parent.floatValue * self.totalCount],@"multiple":self.startBeiShu,@"rate":self.rate,@"lowestYield":self.rate,@"periods":self.poids};
    NSDictionary *commitDic = @{@"params":[params jsonEncodedKeyValueString],REQUEST_WEB_API:currentRequestApi};
    [[DZRequest shareInstance] requestWithPDictionaryaramter:commitDic requestFinish:^(NSDictionary *result) {
        NSLog(@"result:%@",result);
        NSDictionary *respond = result[@"result"];
        if (respond && respond[@"count"]) {
            
            if (respond[@"list"]) {
                NSArray *list = respond[@"list"];
                NSMutableString *multiple = [[NSMutableString alloc] init];
                for (NSDictionary *dic in list) {
                    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [multiple appendFormat:@"%@,",dic[@"multiple"]];
                    [self.dataSource addObject:mDic];
                }
                if (multiple.length >= 2) {
                 tzBeishu = [multiple substringToIndex:multiple.length-1];
                }
            }
            [self requestQiShu:respond[@"count"]];
        }
    } requestFaile:^(NSString *error) {
        
    }];
}

//根据追号机过的count值获取期数信息
-(void)requestQiShu:(NSString *)count{
    DZPoidsQueryRequest *request = [[DZPoidsQueryRequest alloc] init];
    request.lotteryId = [DZAllCommon shareInstance].currentLottyKind.id;
    request.periods = count;
    [[DZRequest shareInstance] requestWithParamter:request requestFinish:^(NSDictionary *result) {
        NSLog(@"result:%@",result);
        if (result[@"result"]) {
            NSDictionary *respond = result[@"result"];
            NSArray *periods = respond[@"periods"];
            for (int i = 0;i < periods.count;i++) {
                NSMutableDictionary *mDic = self.dataSource[i];
                [mDic setObject:periods[i] forKey:@"period"];
            }
        }
        [self.tableview reloadData];
    } requestFaile:^(NSString *error) {
        
    }];
}

//中奖后是否停止追号
- (IBAction)isStopButton:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        isStopWhenWin = @"0";
    }else{
        isStopWhenWin = @"1";
    }
}

//最小盈利或固定倍率
- (IBAction)zxylOrGdbl:(UIButton *)sender {
    NSString *title = [sender titleForState:UIControlStateNormal];
    [self.dataSource removeAllObjects];
    [self.tableview reloadData];
    if ([title isEqualToString:ZXYL]) {
        [self.changeYLORBL setTitle:GDBL forState:UIControlStateNormal];
        //最小盈利
        self.rate = @"100";
        currentRequestApi = LowestYieldLotteryChasePlanGenerator;
        [self.rateButton setTitle:@"最小盈利100%" forState:UIControlStateNormal];
    }else if ([title isEqualToString:GDBL]){
        //固定倍率
        [self.changeYLORBL setTitle:ZXYL forState:UIControlStateNormal];
        self.rate = @"1";
        currentRequestApi = FixedRateLotteryChasePlanGenerator;
        [self.rateButton setTitle:@"倍率1倍" forState:UIControlStateNormal];
    }
    [self requestGaoJiZhuiHao];
}

//购买
- (IBAction)shouldBuy:(UIButton *)sender {
    [self buyLottery];
}

//投注
-(void)buyLottery{
    NSDictionary *playDic = [[DZAllCommon shareInstance].currentLottyKind.plays lastObject];
    NSString *lotteryId = [DZAllCommon shareInstance].currentLottyKind.id;
    NSString *lotteryPlayId = playDic[@"id"];
    NSMutableArray *shoulArr = [[NSMutableArray alloc] init];
    for ( id str in self.selectedArr) {
        if ([str isKindOfClass:[NSArray class]]) {
            NSArray *strArr = (NSArray *)str;
            NSString *strValue = [strArr componentsJoinedByString:@","];
            [shoulArr addObject:@{@"lotteryNumbers":strValue,@"lotteryPlayId":lotteryPlayId}];
        }else{
            NSString *strValue = (NSString *)str;
         [shoulArr addObject:@{@"lotteryNumbers":strValue,@"lotteryPlayId":lotteryPlayId}];
        }
    }
    NSMutableArray *details = [[NSMutableArray alloc] init];
    //投注倍数
    NSArray *tzbss = [tzBeishu componentsSeparatedByString:@","];

    int totleBeishu = 0;
     for (int i = 0; i < tzbss.count; i++) {
        NSDictionary *lotteryNUmbers = @{@"multiple":tzbss[i],@"detailNumbers":shoulArr};
        [details addObject:lotteryNUmbers];
         totleBeishu += [tzbss[i] intValue];
    }

    NSDictionary *resultDic = @{@"account":[DZAllCommon shareInstance].userInfoMation.account,@"details":details,@"lotteryId":lotteryId,@"pattern":self.parent,@"autoCancelOrderWhenWinning":[NSNumber numberWithBool:isStopWhenWin.boolValue]};
    NSDictionary *commitDic = @{@"lotteryOrderInfo":[resultDic jsonEncodedKeyValueString],REQUEST_WEB_API:[DZAllCommon shareInstance].allServiceRespond.lotteryOrderCreate};
    [[DZRequest shareInstance] requestWithPDictionaryaramter:commitDic requestFinish:^(NSDictionary *result) {
        if ([result[@"success"] intValue] == 1) {
            
            NSDictionary *resultDic = result[@"result"];
            DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
            userInfoMation.balance = resultDic[@"balance"];
            userInfoMation.score = resultDic[@"score"];
            [DZUtile saveData];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserBlance object:nil];
            DZBuySuccessViewController *successController = [self.storyboard instantiateViewControllerWithIdentifier:@"DZBuySuccessViewController"];
            [self.navigationController pushViewController:successController animated:YES];
        }else{
            [DZUtile showAlertViewWithMessage:result[@"errorMessage"]];
        }
    } requestFaile:^(NSString *error) {
        
    }];
}

//输入模式 追号倍数等
-(IBAction)showInputField:(id)sender{
    currentBtn = (UIButton *)sender;
    NSString *tip = @"";
    if (currentBtn.tag == 101) {
        //起始倍数
        tip = @"请输入起始倍数";
    }else if (currentBtn.tag == 102){
        //追号多少期
        tip = @"请输入追号期数";
    }else if (currentBtn.tag == 103){
        //倍率
            tip = @"请输入倍率";

        if ([currentRequestApi isEqualToString:LowestYieldLotteryChasePlanGenerator]) {
            //最小盈利
            tip = @"请输入最小盈利";
        }
    }
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:tip message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    UITextField *filed = [dialog textFieldAtIndex:0];
    filed.placeholder = tip;
    [dialog show];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *filed = [alertView textFieldAtIndex:0];
        if (filed.text.intValue == 0 || filed.text.length == 0) {

            return;
        }
        if (currentBtn.tag == 101) {
            //起始倍数
            [currentBtn setTitle:[NSString stringWithFormat:@"起始%@倍",filed.text] forState:UIControlStateNormal];
            self.startBeiShu = filed.text;
        }else if (currentBtn.tag == 102){
            //追号多少期
            [currentBtn setTitle:[NSString stringWithFormat:@"追号%@期",filed.text] forState:UIControlStateNormal];
            self.poids = filed.text;
        }else if (currentBtn.tag == 103){
            //倍率或最小盈利
            if ([currentRequestApi isEqualToString:LowestYieldLotteryChasePlanGenerator]) {
                //最小盈利
                if (filed.text.intValue > 100) {
                    [DZUtile showAlertViewWithMessage:@"最小盈利为0～100之间"];
                    return;
                }
            [currentBtn setTitle:[NSString stringWithFormat:@"最小盈利%@%%",filed.text] forState:UIControlStateNormal];
            }else if ([currentRequestApi isEqualToString:FixedRateLotteryChasePlanGenerator]){
                //固定倍率
            [currentBtn setTitle:[NSString stringWithFormat:@"倍率%@倍",filed.text] forState:UIControlStateNormal];
            }
            self.rate = filed.text;
        }
        buyInfoLabel.text = [NSString stringWithFormat:@"共%d注，%.2f元",self.totalCount,self.totalCount * profit * self.parent.floatValue * self.poids.intValue * self.startBeiShu.intValue];
            [self requestGaoJiZhuiHao];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataSource[indexPath.row];
    //期号
    UILabel *qiHao = (UILabel *)[cell.contentView viewWithTag:100];
    qiHao.text = dic[@"period"];
    //倍数
    UILabel *beishu = (UILabel *)[cell.contentView viewWithTag:101];
    beishu.text = [NSString stringWithFormat:@"%d",[dic[@"multiple"] intValue]];
    //累计投入
    UILabel *leijitouru = (UILabel *)[cell.contentView viewWithTag:102];
    leijitouru.text = [NSString stringWithFormat:@"%.2f",[dic[@"totalPrincipal"] floatValue]];
    //中奖盈利
    UILabel *zhongjiangyingli = (UILabel *)[cell.contentView viewWithTag:103];
    zhongjiangyingli.text = [NSString stringWithFormat:@"%.2f",[dic[@"profit"] floatValue]];
    //盈利率
    UILabel *yinglilv = (UILabel *)[cell.contentView viewWithTag:104];
    yinglilv.text = [NSString stringWithFormat:@"%.2f%%",[dic[@"yield"] floatValue]];
}

- (IBAction)changeParent:(id)sender {
    currentBtn = (UIButton *)sender;
    parentSheet = [[UIActionSheet alloc] initWithTitle:@"请选择模式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"1元模式" otherButtonTitles:@"1角模式",@"1分模式", nil];
    [parentSheet showInView:self.view];
}

#pragma UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
 
        if (buttonIndex == 3) {
            return;
        }
        if (buttonIndex == 0) {
            //1元模式
            self.parent = @"1";
            [currentBtn setTitle:@"模式1元" forState:UIControlStateNormal];
            
        }else if (buttonIndex == 1){
            //1角模式
            self.parent = @"0.1";
            [currentBtn setTitle:@"模式1角" forState:UIControlStateNormal];
        }else if (buttonIndex == 2){
            //1分模式
            self.parent = @"0.01";
            [currentBtn setTitle:@"模式1分" forState:UIControlStateNormal];
        }
        buyInfoLabel.text = [NSString stringWithFormat:@"共%d注，%.2f元",self.totalCount,self.totalCount * profit * self.parent.floatValue * self.poids.intValue * self.startBeiShu.intValue];
        [self requestGaoJiZhuiHao];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
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
