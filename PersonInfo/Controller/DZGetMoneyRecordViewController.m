//
//  DZGetMoneyRecordViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/11.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZGetMoneyRecordViewController.h"
#import "DZGetMoneyRecordTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "DZGetMoneyRecordRequest.h"
#import "DZGetMoneyRecordRespond.h"
static NSString *const DZGetMoneyRecordTableViewCell_Indentify = @"DZGetMoneyRecordTableViewCell";
@interface DZGetMoneyRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) DZGetMoneyRecordRequest *request;
@end

@implementation DZGetMoneyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.request = [[DZGetMoneyRecordRequest alloc] init];
    [self registTableViewCell];
    [self reset];
}

-(void)registTableViewCell{
    [self.tableview registerNib:[UINib nibWithNibName:DZGetMoneyRecordTableViewCell_Indentify bundle:nil] forCellReuseIdentifier:DZGetMoneyRecordTableViewCell_Indentify];
}

-(void)reset{
    
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //刷新
        [self refreash];
    }];
    self.tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 加载更多
        [self loadMoreData];
    }];
    [self.tableview.header beginRefreshing];
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
                DZGetMoneyRecordRespond *respond = [[DZGetMoneyRecordRespond alloc] initWithDic:dic];
                [self.dataSource addObject:respond];
            }
            [self.tableview reloadData];
            if (self.dataSource.count == 0) {
                [self.tableview.footer endRefreshing];
                [self.tableview.header endRefreshing];
                [DZUtile showAlertViewWithMessage:@"暂无数据"];
                return;
            }else if (self.dataSource.count <  self.request.pageCount){
                [self.tableview.footer noticeNoMoreData];
            }
        }
    } requestFaile:^(NSString *result) {
        
    }];
    [self.tableview.header endRefreshing];
}

//加载更多
-(void)loadMoreData{
    
    self.request.pageIndex += 1;
    [[DZRequest shareInstance] requestWithParamter:self.request requestFinish:^(NSDictionary *result) {
        NSArray *results = result[@"result"];
        if (results) {
            for (NSDictionary *dic in results){
                DZGetMoneyRecordRespond *respond = [[DZGetMoneyRecordRespond alloc] initWithDic:dic];
                [self.dataSource addObject:respond];
            }
            [self.tableview reloadData];
            if (results.count == 0) {
                [self.tableview.footer endRefreshing];
                [self.tableview.header endRefreshing];
                [self.tableview.footer noticeNoMoreData];
                [DZUtile showAlertViewWithMessage:@"暂无更多数据"];
                return;
            }
        }
    } requestFaile:^(NSString *result) {
        
    }];
    [self.tableview.footer endRefreshing];
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
    DZGetMoneyRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DZGetMoneyRecordTableViewCell_Indentify forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(DZGetMoneyRecordTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZGetMoneyRecordRespond *respond = self.dataSource[indexPath.row];
    [cell replay:respond];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67.0f;
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
