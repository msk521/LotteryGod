//
//  DZCoolAndHotNumController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/13.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZCoolAndHotNumController.h"
#import "VKCoolOrHotNumberTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "DZLottySearchRequet.h"
#import "DZLastWinNumberRespond.h"
static NSString *const VKCoolOrHotNumberTableViewCell_Indentify = @"CoolOrHotNumberTableViewCell";
@interface DZCoolAndHotNumController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) DZLottySearchRequet *lastRequest;
@end

@implementation DZCoolAndHotNumController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.lastRequest = [[DZLottySearchRequet alloc] init];
    self.lastRequest.pageCount = 100;
    [self refreash];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


-(void)reset{
    self.tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //刷新
        [self refreash];
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
            results = [[results reverseObjectEnumerator] allObjects];
            for (NSDictionary *dic in results){
                DZLastWinNumberRespond *respond = [[DZLastWinNumberRespond alloc] initWithDic:dic];
                [self.dataSource addObject:respond];
            }
            
            [self.tableview reloadData];
            
            if (self.dataSource.count == 0) {
                [DZUtile showAlertViewWithMessage:@"暂无数据"];
                return;
            }
        }
    } requestFaile:^(NSString *result) {
        
    }];
}


//求出现次数
-(NSMutableDictionary *)calculationAppears:(NSArray *)dataSource{
    NSMutableDictionary *calculationDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < dataSource.count; i++) {
        DZLastWinNumberRespond *respond = dataSource[i];
        NSArray *numbers = [respond.numbers componentsSeparatedByString:@","];
        for (NSString *numb in numbers) {
            NSMutableArray *number = calculationDic[@(numb.intValue)];
            if (!number) {
                number = [[NSMutableArray alloc] init];
                [calculationDic setObject:number forKey:@(numb.intValue)];
            }
            [number addObject:@(numb.intValue)];
        }
    }
    return calculationDic;
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VKCoolOrHotNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VKCoolOrHotNumberTableViewCell_Indentify forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(VKCoolOrHotNumberTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{

    int count = 0;
    if (indexPath.row == 0 ) {
        count = 20;
    }else if (indexPath.row == 1){
        count = 50;
    }else if (indexPath.row == 2){
        count = 100;
    }
    if (self.dataSource.count >= count) {
       NSDictionary *dic = [self calculationAppears:[self.dataSource subarrayWithRange:NSMakeRange(0, count)]];
        [cell replay:dic  totalNum:count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
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
