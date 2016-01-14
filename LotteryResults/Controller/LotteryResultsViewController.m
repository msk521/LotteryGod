//
//  LotteryResultsViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/3.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "LotteryResultsViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "DZResult.h"
#import "DZResultTableViewCell.h"
#import "DZLottySearchRequet.h"
#import "DZRequest.h"
#import "DZLastWinNumberRespond.h"
#import "DZLottyKindsRespond.h"
#define CellIndentify @"DZResultTableViewCell"
@interface LotteryResultsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIButton *resultTitle;
@property (nonatomic,strong) DZLottySearchRequet *lastRequest;
@end

@implementation LotteryResultsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DZLottyKindsRespond *current = [DZAllCommon shareInstance].currentLottyKind;
    [self.resultTitle setTitle:[NSString stringWithFormat:@"%@-开奖结果",current.name] forState:UIControlStateNormal];
    self.lastRequest = [[DZLottySearchRequet alloc] init];
    [self refreash];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 10.0f;

    [self reset];
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
}

//刷新
-(void)refreash{
    [self.dataSource removeAllObjects];
    //刷新当前开奖情况
    self.lastRequest.pageIndex = 0;
    [[DZRequest shareInstance] requestWithParamter:self.lastRequest requestFinish:^(NSDictionary *result) {
        NSArray *results = result[@"result"];
        if (results) {
            for (NSDictionary *dic in results){
                 DZLastWinNumberRespond *respond = [[DZLastWinNumberRespond alloc] initWithDic:dic];
                [self.dataSource addObject:respond];
            }
            [self.resultTableView reloadData];
            if (self.dataSource.count == 0) {
                [self.resultTableView.footer endRefreshing];
                [self.resultTableView.header endRefreshing];
                [DZUtile showAlertViewWithMessage:@"暂无数据"];
                return;
            }else if (self.dataSource.count <  self.lastRequest.pageCount){
                [self.resultTableView.footer noticeNoMoreData];
            }
        }
    } requestFaile:^(NSString *result) {
        
    }];
     [self.resultTableView.header endRefreshing];
}

//加载更多
-(void)loadMoreData{

    self.lastRequest.pageIndex += 1;
    [[DZRequest shareInstance] requestWithParamter:self.lastRequest requestFinish:^(NSDictionary *result) {
        NSArray *results = result[@"result"];
        if (results) {
//             results = [[results reverseObjectEnumerator] allObjects];
            for (NSDictionary *dic in results){
                DZLastWinNumberRespond *respond = [[DZLastWinNumberRespond alloc] initWithDic:dic];
                [self.dataSource addObject:respond];
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
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZResultTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentify forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(DZResultTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count <= indexPath.row) {
        return;
    }
    DZLastWinNumberRespond *result = self.dataSource[indexPath.row];
    [cell replay:result];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0f;
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
