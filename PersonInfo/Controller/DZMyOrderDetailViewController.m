//
//  DZMyOrderDetailViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/1.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZMyOrderDetailViewController.h"
#import "DZCancelOrderRequest.h"
#import "DZOrderDetailTableViewCell.h"
#import "DZOrderDetailHeaderView.h"
#import "DZShowBuyDetailView.h"
#import "DZOrdereDetailRequest.h"
static NSString *const DZOrderDetailTableViewCell_Indentify = @"DZOrderDetailTableViewCell";
@interface DZMyOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    //中奖金额
    __weak IBOutlet UILabel *winMoney;
    //订单金额
    __weak IBOutlet UILabel *orderMoney;
    //共多少期
    __weak IBOutlet UILabel *poids;
    //彩种名称
    __weak IBOutlet UILabel *lottryName;
    //创建时间
    __weak IBOutlet UILabel *createTimeLabel;
    //撤单
    __weak IBOutlet UIButton *cancelOrderButton;
    DZMyOrderListRespond *currentRespond;
    //开始期号
    __weak IBOutlet UILabel *startPoidNum;
    __weak IBOutlet UILabel *backLabel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) DZShowBuyDetailView *showDetailView;
@end

@implementation DZMyOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview registerNib:[UINib nibWithNibName:DZOrderDetailTableViewCell_Indentify bundle:nil] forCellReuseIdentifier:DZOrderDetailTableViewCell_Indentify];
    [self initOrderDetail];
    self.showDetailView = [[[NSBundle mainBundle] loadNibNamed:@"DZShowBuyDetailView" owner:self options:nil] firstObject];
    self.showDetailView.hidden = YES;
    [self.view addSubview:self.showDetailView];
    [self requestDetails];
}

//获取详情
-(void)requestDetails{
    DZOrdereDetailRequest *request = [[DZOrdereDetailRequest alloc] init];
    request.orderId = self.orderRespond.id;
    [[DZRequest shareInstance] requestWithParamter:request requestFinish:^(NSDictionary *respond) {
        if ([respond[@"success"] intValue] == 1) {
            self.orderRespond.details = respond[@"result"];
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:self.orderRespond.details];
            [self.tableview reloadData];
        }else{
            [DZUtile showAlertViewWithMessage:respond[@"errorMessage"]];
        }
    } requestFaile:^(NSString *error) {
        
    }];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithArray:self.orderRespond.details];
    }
    return _dataSource;
}

-(void)initOrderDetail{
    
    currentRespond = self.orderRespond;
    //开始期号
    NSDictionary *firstPoids = [currentRespond.details firstObject];
    if (firstPoids) {
        startPoidNum.text = [NSString stringWithFormat:@"开始期号:%@",firstPoids[@"period"]];
    }else{
        startPoidNum.text = [NSString stringWithFormat:@"开始期号:%@",currentRespond.currentPeriod];
    }
    //奖金
    winMoney.text = [NSString stringWithFormat:@"奖金:%@",currentRespond.totalProfit];
    //投注金额
    orderMoney.text = [NSString stringWithFormat:@"投注金额:%@元",currentRespond.totalPrincipal];
    //追号期数
    poids.text = [NSString stringWithFormat:@"追号期数:%@期",currentRespond.totalPeriods];
    //彩种
    lottryName.text = [NSString stringWithFormat:@"彩种:%@",currentRespond.lotteryName];
    //创建时间
    createTimeLabel.text = [NSString stringWithFormat:@"下单时间:%@",currentRespond.createTime];
    if (currentRespond.finished.intValue == 0) {
        cancelOrderButton.hidden = NO;
        backLabel.hidden = YES;
    }else{
        cancelOrderButton.hidden = YES;
        backLabel.hidden = NO;
    }
}

//查看投注详情
- (IBAction)lookBuyDetail:(UIButton *)sender {
    
    if (self.showDetailView) {
        if (self.showDetailView.hidden) {
            self.showDetailView.hidden = NO;
            CGAffineTransform newTransform =
            CGAffineTransformScale(self.showDetailView.transform, 0.1, 0.1);
            self.showDetailView.transform = newTransform;
            self.showDetailView.center = self.view.center;
            [UIView animateWithDuration:0.5f animations:^{
                CGAffineTransform ntransform = CGAffineTransformConcat(self.showDetailView.transform,CGAffineTransformInvert(self.showDetailView.transform));
                self.showDetailView.transform = ntransform;
                self.showDetailView.alpha = 1.0;
                self.showDetailView.center = self.view.center;
            } completion:^(BOOL finished) {
                [self.showDetailView replay:currentRespond];
            }];
        }
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
                cancelOrderButton.hidden = YES;
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
    DZOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DZOrderDetailTableViewCell_Indentify forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(DZOrderDetailTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataSource.count) {
        NSDictionary *dic = self.dataSource[indexPath.row];
        [cell replay:dic number:(int)indexPath.row + 1];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"DZOrderDetailHeaderView" owner:self options:nil] firstObject];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0f;
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
