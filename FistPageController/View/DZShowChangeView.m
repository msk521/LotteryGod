//
//  DZShowChangeView.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/6.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZShowChangeView.h"
#import "DZLottyKindsRequest.h"
#import "DZRequest.h"
#import "DZCityTableViewCell.h"
#import "DZLastWinNumberRequest.h"
#import "DZLastWinNumberRespond.h"
#import "DZAllServiceRespond.h"
#define LottyKinds @"LottyKinds"
static NSString *const DZCityTableViewCell_Indentify = @"DZCityTableViewCell";
@interface DZShowChangeView()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *dataSource;
    DZLottyKindsRespond *selectedLotty;
}
@end
@implementation DZShowChangeView
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

-(void)requestCitys{
    
    [self requestService];
}

-(void)requestLottyKinds:(NSString *)requestURL{
    
    [self.tableview registerNib:[UINib nibWithNibName:DZCityTableViewCell_Indentify bundle:nil] forCellReuseIdentifier:DZCityTableViewCell_Indentify];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    
    DZLottyKindsRequest *request = [[DZLottyKindsRequest alloc] init];
    request.requestApi = requestURL;

       __weak DZShowChangeView *main = self;
    [[DZRequest shareInstance] requestWithParamter:request requestFinish:^(NSDictionary *result) {
        for (NSDictionary *dic in result[@"result"]) {
            DZLottyKindsRespond *fpTop = [[DZLottyKindsRespond alloc] initWithDic:dic];
            [main.dataSource addObject:fpTop];
        }
        
        if (main.dataSource.count > 0) {
            [DZAllCommon shareInstance].currentLottyKind = [main.dataSource firstObject];
            [[NSNotificationCenter defaultCenter] postNotificationName:RESTLOTTYNAME object:nil];
        }
        [self lastWinNumber];
        [main.tableview reloadData];
    } requestFaile:^(NSString *result) {
        
    }];
}

//获取所有请求地址
-(void)requestService{
    DZBaseRequestModel *allService = [[DZBaseRequestModel alloc] init];
    allService.requestApi = ServiceURL;

    [[DZRequest shareInstance] requestWithParamter:allService requestFinish:^(NSDictionary *result) {
        if (result[@"result"]) {
            DZAllServiceRespond *respond = [[DZAllServiceRespond alloc] initWithDic:result[@"result"]];
            [DZAllCommon shareInstance].allServiceRespond = respond;
            [self requestLottyKinds:respond.lotterys];
        }
    } requestFaile:^(NSString *result) {
        
    }];
}


//刷新当前开奖情况
-(void)lastWinNumber{
    DZLastWinNumberRequest *lastRequest = [[DZLastWinNumberRequest alloc] init];
    [[DZRequest shareInstance] requestWithParamter:lastRequest requestFinish:^(NSDictionary *result) {
        NSDictionary *dic = result[@"result"];
        if (dic) {
            DZLastWinNumberRespond *respond = [[DZLastWinNumberRespond alloc] initWithDic:dic];
            if (self.changeLottyKind) {
                self.changeLottyKind(respond);
            }
        }
    } requestFaile:^(NSString *result) {
        
    }];
}

//隐藏view
- (IBAction)hiddenView:(UIButton *)sender {
    if (self.hiddenView) {
        self.hiddenView();
    }
}

//确认选择城市
- (IBAction)selectedShould:(UIButton *)sender {
    if (self.hiddenView) {
        self.hiddenView();
    }
    if (self.showView) {
        [DZAllCommon shareInstance].currentLottyKind = selectedLotty;
        [self lastWinNumber];
        self.showView(selectedLotty);
    }
}

-(NSMutableArray *)dataSource{
    if (!dataSource) {
        dataSource = [[NSMutableArray alloc] init];
    }
    return dataSource;
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
    DZCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DZCityTableViewCell_Indentify forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(DZCityTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataSource.count) {
        DZLottyKindsRespond *fpTop = self.dataSource[indexPath.row];
        cell.textLabel.text = fpTop.name;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataSource.count) {
        DZLottyKindsRespond *fpTop = self.dataSource[indexPath.row];
        selectedLotty = fpTop;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 37.0f;
}


@end
