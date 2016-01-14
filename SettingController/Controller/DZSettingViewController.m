//
//  DZSettingViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/13.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZSettingViewController.h"
#import "AppDelegate.h"
@interface DZSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation DZSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.dataSource addObject:@"关闭音效"];
    [self.dataSource addObject:@"版本信息"];
    [self.dataSource addObject:@"关于我们"];
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
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCloseMusic" forIndexPath:indexPath];

        UISwitch *switchButton = (UISwitch *)[cell viewWithTag:100];
        NSUserDefaults *defaulters = [NSUserDefaults standardUserDefaults];
        [switchButton setOn:YES];
        if ([[defaulters objectForKey:@"closeMusic"] intValue] == 0) {
            [switchButton setOn:NO];
        }
        [switchButton addTarget:self action:@selector(closeMusic:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}
/**
 *  打开或关闭音效
 */
-(void)closeMusic:(UISwitch *)sender{
    NSUserDefaults *defaulters = [NSUserDefaults standardUserDefaults];
    if (sender.isOn) {
        [defaulters setObject:@(1) forKey:@"closeMusic"];
    }else{
        [defaulters setObject:@(0) forKey:@"closeMusic"];
    }
    [defaulters synchronize];
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.detailTextLabel.text = @"";
    if (indexPath.row == 1) {
        NSString *number = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"V%@",number];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.dataSource.count - 1) {
        [DZUtile showAlertViewWithMessage:@"澳门犀牛博彩有限公司"];
    }else if (indexPath.row == 1){
        //版本信息
        [DZUtile checkVersion:self];
    }
}

#pragma mark---UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title =  [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"升级"]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *updateURL = delegate.respond.itmsServicesUrl;
        if (!updateURL) {
            updateURL = UPDATEURL;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UPDATEURL]];
    }
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
