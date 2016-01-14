//
//  DZPersonInfoMationViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/17.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZPersonInfoMationViewController.h"

@interface DZPersonInfoMationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation DZPersonInfoMationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        DZUserInfoMation *userInfo = [DZAllCommon shareInstance].userInfoMation;
        NSString *sex = [userInfo.sex isEqualToString:@"false"]?@"男":@"女";
        _dataSource = [[NSMutableArray alloc] init];
        [_dataSource addObject:@{@"name":@"登录帐号",@"value":userInfo.account}];
        [_dataSource addObject:@{@"name":@"姓名",@"value":userInfo.name}];
        [_dataSource addObject:@{@"name":@"账户余额(金币)",@"value":userInfo.balance}];
        [_dataSource addObject:@{@"name":@"账户余额(银币)",@"value":userInfo.score}];
        [_dataSource addObject:@{@"name":@"手机号码",@"value":userInfo.phone}];
        [_dataSource addObject:@{@"name":@"性别",@"value":sex}];
        [_dataSource addObject:@{@"name":@"生日",@"value":userInfo.birthday}];
        [_dataSource addObject:@{@"name":@"QQ",@"value":userInfo.qq}];
        [_dataSource addObject:@{@"name":@"邮箱",@"value":userInfo.email}];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    //标题
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    nameLabel.text = dic[@"name"];
    //值
    UILabel *valueLabel = (UILabel *)[cell viewWithTag:101];
    valueLabel.text = dic[@"value"];
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
