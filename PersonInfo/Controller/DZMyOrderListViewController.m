
//
//  DZMyOrderListViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/31.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZMyOrderListViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "DZUserOrderListRequest.h"
#import "DZMyOrderListRespond.h"
#import "DZMyOrderTableViewCell.h"
#import "DZCancelOrderRequest.h"
#import "DZMyOrderDetailViewController.h"
#import "DZShowBuyDetailView.h"
static NSString *const DZMyOrderTableViewCell_Indentify = @"DZMyOrderTableViewCell";
@interface DZMyOrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (nonatomic,strong) DZUserOrderListRequest *request;
@property (nonatomic,strong) DZShowBuyDetailView *showDetailView;
@end

@implementation DZMyOrderListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.resultTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registTableViewCell];
    self.request = [[DZUserOrderListRequest alloc] init];
    [self reset];
    self.showDetailView = [[[NSBundle mainBundle] loadNibNamed:@"DZShowBuyDetailView" owner:self options:nil] firstObject];
    self.showDetailView.hidden = YES;
    [self.view addSubview:self.showDetailView];
}

//注册cell
-(void)registTableViewCell{
    [self.resultTableView registerNib:[UINib nibWithNibName:DZMyOrderTableViewCell_Indentify bundle:nil] forCellReuseIdentifier:DZMyOrderTableViewCell_Indentify];
}

-(void)reset{
    self.resultTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //刷新
        [self refreash];
    }];
    self.resultTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载更多
        [self loadMoreData];
    }];
    [self.resultTableView.header beginRefreshing];
}

//刷新
-(void)refreash{
    [self.dataSource removeAllObjects];
    //刷新当前开奖情况
    [self.hud show:YES];
    self.request.pageIndex = 0;
    [[DZRequest shareInstance] requestWithParamter:self.request requestFinish:^(NSDictionary *result) {
        [self.hud hide:YES];
        NSArray *results = result[@"result"];
        if (results) {
            
            for (NSDictionary *dic in results){
                DZMyOrderListRespond *myOrderList = [[DZMyOrderListRespond alloc] initWithDic:dic];
                [self.dataSource addObject:myOrderList];
            }
            [self.resultTableView reloadData];
            if (self.dataSource.count == 0) {
                [self.resultTableView.footer endRefreshing];
                [self.resultTableView.header endRefreshing];
                [self.resultTableView.footer noticeNoMoreData];
                [DZUtile showAlertViewWithMessage:@"暂无数据"];
                return;
            }else if (self.dataSource.count <  self.request.pageCount){
                [self.resultTableView.footer noticeNoMoreData];
            }
        }
    } requestFaile:^(NSString *result) {
       
    }];
    [self.resultTableView.header endRefreshing];
}

//加载更多
-(void)loadMoreData{
    [self.hud show:YES];
    self.request.pageIndex += 1;
    [[DZRequest shareInstance] requestWithParamter:self.request requestFinish:^(NSDictionary *result) {
        [self.hud hide:YES];
        NSArray *results = result[@"result"];
        if (results) {
            for (NSDictionary *dic in results){
                DZMyOrderListRespond *myOrderList = [[DZMyOrderListRespond alloc] initWithDic:dic];
                [self.dataSource addObject:myOrderList];
            }
            [self.resultTableView reloadData];
            if (results.count == 0) {
                [self.resultTableView.footer endRefreshing];
                [self.resultTableView.header endRefreshing];
                [self.resultTableView.footer noticeNoMoreData];
                [DZUtile showAlertViewWithMessage:@"暂无更多数据"];
                return;
            }
        }
    } requestFaile:^(NSString *result) {
        
    }];
    [self.resultTableView.footer endRefreshing];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
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
    DZMyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DZMyOrderTableViewCell_Indentify forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(DZMyOrderTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    DZMyOrderListRespond *respond = self.dataSource[indexPath.row];
    cell.cancelOrder = ^(NSString *orderId){
        //撤单
        DZCancelOrderRequest *requestCancel = [[DZCancelOrderRequest alloc] init];
        requestCancel.lotteryOrderId = respond.id;
        [[DZRequest shareInstance] requestWithParamter:requestCancel requestFinish:^(NSDictionary *result) {
            if ([result[@"success"] intValue] == 1) {
                [DZUtile showAlertViewWithMessage:result[@"result"]];
                respond.finished = @"1";
                [self.resultTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                [DZUtile showAlertViewWithMessage:result[@"errorMessage"]];
            }
        } requestFaile:^(NSString *result) {
            
        }];
    };
    
    cell.lookDetail = ^(DZMyOrderListRespond *respond){
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
                    [self.showDetailView replay:respond];
                }];
            }
        }
    };
    [cell replay:respond];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DZMyOrderListRespond *respond = self.dataSource[indexPath.row];
    DZMyOrderDetailViewController *orderDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"DZMyOrderDetailViewController"];
    orderDetail.orderRespond = respond;
    [self.navigationController pushViewController:orderDetail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= self.dataSource.count) {
        return 0;
    }
    DZMyOrderListRespond *respond = self.dataSource[indexPath.row];

    if (respond.finished.intValue != 0) {
        
        return 161.0 - 30;
    }
    return 161.0f;
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
