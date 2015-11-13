//
//  IncomeStatementViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/9.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "IncomeStatementViewController.h"
#import "DZIncomeStatement.h"
#import "DZRequestDetailRequest.h"
#import <MJRefresh/MJRefresh.h>
@interface IncomeStatementViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) DZRequestDetailRequest *request;
@end

@implementation IncomeStatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.request = [[DZRequestDetailRequest alloc] init];
    self.request.requestApi = [DZAllCommon shareInstance].allServiceRespond.userBalanceChange;
    self.request.type = @"balance";//金币
    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
    if (!userInfoMation.account || userInfoMation.account.length == 0) {
        DZLoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"DZLoginViewController"];
        [DZUtile showLoginViewController:loginView animation:YES finishLoading:^{
            
        }hiddenFinish:^{
            DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
            self.request.account = userInfoMation.account;
            [self reset];
        }];
    }else{
        self.request.account = userInfoMation.account;
        [self reset];
    }
}
/**
 *  重新父类初始化
 */
-(void)initData{
    
}
//金币 银币
- (IBAction)changeBalaceAction:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if (seg.selectedSegmentIndex == 0) {
        self.request.type = @"balance";//金币
    }else{
        self.request.type = @"score";//金币
    }
    [self refreash];
}

-(void)reset{
    
    self.historyTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //刷新
        [self refreash];
    }];
    self.historyTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载更多
        [self loadMoreData];
    }];
    [self.historyTableView.header beginRefreshing];
}


//刷新
-(void)refreash{
    [self.dataSource removeAllObjects];
    //刷新当前开奖情况
    self.request.pageIndex = 0;
    [[DZRequest shareInstance] requestWithParamter:self.request requestFinish:^(NSDictionary *result) {
        NSArray *results = result[@"result"];
        if (results) {
            for (NSDictionary *dic in results){
                DZIncomeStatement *income = [[DZIncomeStatement alloc] initWithDic:dic];
                [self.dataSource addObject:income];
            }
            [self.historyTableView reloadData];
            if (self.dataSource.count == 0) {
                [self.historyTableView.footer endRefreshing];
                [self.historyTableView.header endRefreshing];
                [DZUtile showAlertViewWithMessage:@"暂无数据"];
                return;
            }else if (self.dataSource.count <  self.request.pageCount){
                [self.historyTableView.footer noticeNoMoreData];
            }
        }
    } requestFaile:^(NSString *result) {
        
    }];
    [self.historyTableView.header endRefreshing];
}

//加载更多
-(void)loadMoreData{
    
    self.request.pageIndex += 1;
    [[DZRequest shareInstance] requestWithParamter:self.request requestFinish:^(NSDictionary *result) {
        NSArray *results = result[@"result"];
        if (results) {
            for (NSDictionary *dic in results){
                DZIncomeStatement *income = [[DZIncomeStatement alloc] initWithDic:dic];
                [self.dataSource addObject:income];
            }
            [self.historyTableView reloadData];
            if (results.count == 0) {
                [self.historyTableView.footer endRefreshing];
                [self.historyTableView.header endRefreshing];
                [self.historyTableView.footer noticeNoMoreData];
                [DZUtile showAlertViewWithMessage:@"暂无更多数据"];
                return;
            }
        }
    } requestFaile:^(NSString *result) {
        
    }];
    [self.historyTableView.footer endRefreshing];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"incomestatement" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    DZIncomeStatement *income = self.dataSource[indexPath.row];
    //项目
    UILabel *name = (UILabel *)[cell viewWithTag:100];
    name.text = income.article;
    //金额
    UILabel *amount = (UILabel *)[cell viewWithTag:101];
    NSString *fh = income.action.intValue > 0? @"+":@"-";
    amount.text = [NSString stringWithFormat:@"%@%@",fh,income.amount];
    //余额
    UILabel *balance = (UILabel *)[cell viewWithTag:102];
    balance.text = income.balance;
    //余额
    UILabel *time = (UILabel *)[cell viewWithTag:103];
    time.text = income.time;
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
