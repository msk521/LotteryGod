//
//  DZMyOrderDetailViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/1.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZMyOrderDetailViewController.h"
#import "DZCancelOrderRequest.h"
@interface DZMyOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    //中奖金额
    __weak IBOutlet UILabel *winMoney;
    //中奖状态
    __weak IBOutlet UILabel *winState;
    //订单金额
    __weak IBOutlet UILabel *orderMoney;
    //共多少期
    __weak IBOutlet UILabel *poids;
    //订单号
    __weak IBOutlet UILabel *orderid;
    //彩种名称
    __weak IBOutlet UILabel *lottryName;
    //当前追期
    __weak IBOutlet UILabel *currentZhuiQi;
    __weak IBOutlet UILabel *createTime;
    //撤单
    __weak IBOutlet UIButton *cancelOrder;
}
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation DZMyOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initOrderDetail];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithArray:self.orderRespond.details];
    }
    return _dataSource;
}

-(void)initOrderDetail{
    lottryName.text = self.orderRespond.lotteryName;
    orderid.text = [NSString stringWithFormat:@"订单号:%@",self.orderRespond.id];
    NSString *distion = @"(中奖后撤单)";
    if (self.orderRespond.autoCancelOrderWhenWinning == 0) {
        distion = @"";
    }
    poids.text = [NSString stringWithFormat:@"共%@期%@",self.orderRespond.totalPeriods,distion];
    currentZhuiQi.text = [NSString stringWithFormat:@"已追:%@",self.orderRespond.cancelPeriods];
    createTime.text = [NSString stringWithFormat:@"创建时间:%@",self.orderRespond.createTime];
    orderMoney.text = [NSString stringWithFormat:@"%@元",self.orderRespond.totalPrincipal];
    winMoney.text = [NSString stringWithFormat:@"%@元",self.orderRespond.totalProfit];
    if (!self.orderRespond.totalProfit || [self.orderRespond.totalProfit isEqual:[NSNull null]] || self.orderRespond.totalProfit.length == 0) {
        winMoney.text = @"未开奖";
    }
    winState.text = self.orderRespond.status;
    if (self.orderRespond.finished.intValue == 0) {
        cancelOrder.hidden = NO;
    }
}

-(IBAction)cancelOrder:(id)sender{
    DZMyOrderListRespond *respond = self.orderRespond;
    DZCancelOrderRequest *requestCancel = [[DZCancelOrderRequest alloc] init];
        requestCancel.lotteryOrderId = respond.id;
        [[DZRequest shareInstance] requestWithParamter:requestCancel requestFinish:^(NSDictionary *result) {
            if ([result[@"success"] intValue] == 1) {
                [DZUtile showAlertViewWithMessage:result[@"result"]];
                respond.finished = @"1";
                cancelOrder.hidden = YES;
            }else{
                [DZUtile showAlertViewWithMessage:result[@"errorMessage"]];
            }
        } requestFaile:^(NSString *result) {
            
        }];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataSource.count) {
        NSDictionary *dic = self.dataSource[indexPath.row];
        //第多少期
        UILabel *poidNmae = (UILabel *)[cell viewWithTag:100];
        poidNmae.text = [NSString stringWithFormat:@"%@期",dic[@"period"]];
        //中奖状态
        UILabel *statelabel = (UILabel *)[cell viewWithTag:101];
        statelabel.textColor = [UIColor grayColor];
        if (!dic[@"totalProfit"] || [dic[@"totalProfit"] length] == 0 ) {
            statelabel.text = @"未开奖";
            if ([dic[@"canceled"] intValue] == 1) {
            statelabel.text = @"已撤单";
            }
        }else{
            statelabel.textColor = [UIColor redColor];
            statelabel.text = [NSString stringWithFormat:@"¥%@",dic[@"totalProfit"]];
        }
        //中奖号码
        UILabel *winNumblabel = (UILabel *)[cell viewWithTag:102];
         winNumblabel.text= dic[@"lotteryNumbers"];
    }
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
