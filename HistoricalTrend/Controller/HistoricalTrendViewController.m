//
//  HistoricalTrendViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/3.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "HistoricalTrendViewController.h"
#import "DZHistoricalTrendCell.h"
#import "DZLottySearchRequet.h"
#import "DZRequest.h"
#import "DZLastWinNumberRespond.h"
#import "DZHistoriSetting.h"
#import "DZHistoricalBottomView.h"
#import "AppDelegate.h"
#import "AnlyesSoftwarsViewController.h"
#import "DZBettingViewController.h"
#import "DZShouldBuyViewController.h"
@interface HistoricalTrendViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) float rowHight;
@property (nonatomic,strong) DZHistoriSetting *histroiSettingView;
@property (nonatomic,strong) DZLottySearchRequet *lastRequest;
@property (nonatomic,strong) UIActionSheet *actionSheet;
@property (nonatomic,strong) DZHistoricalBottomView *footView;
@end

static NSString *DZHistoricalTrendCell_Indentify = @"DZHistoricalTrendCell";

@implementation HistoricalTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.lastRequest.pageCount = 20;
    [self registCell];
    [self initHistoriSettingView];
    self.lastRequest = [[DZLottySearchRequet alloc] init];
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择查询期数" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"20期" otherButtonTitles:@"50期",@"100期",@"200期",@"300期", nil];
    [self refreash];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
/**
 *  注册cell
 */
-(void)registCell{
    CGRect frame = [UIScreen mainScreen].bounds;
    float with = frame.size.width/ 12;
    _rowHight = with;
    [self.historyTableView registerClass:NSClassFromString(DZHistoricalTrendCell_Indentify) forCellReuseIdentifier:DZHistoricalTrendCell_Indentify];
}

-(void)initHistoriSettingView{
    AppDelegate *main = [UIApplication sharedApplication].delegate;
    self.histroiSettingView = [[[NSBundle mainBundle] loadNibNamed:@"DZHistoriSetting" owner:self options:nil] firstObject];
    self.histroiSettingView.frame = CGRectMake(0, 0, main.window.bounds.size.width, main.window.bounds.size.height + 50);
    self.histroiSettingView.hidden = YES;
    self.histroiSettingView.alpha = 0.0f;
    __weak HistoricalTrendViewController *domain = self;
    self.histroiSettingView.hiddenView = ^(){
        
        [UIView animateWithDuration:0.5f animations:^{
            CGAffineTransform ntransform = CGAffineTransformScale(domain.histroiSettingView.transform, 0.1, 0.1);
            domain.histroiSettingView.transform = ntransform;
            domain.histroiSettingView.alpha = 0.0;
            domain.histroiSettingView.center = domain.view.center;
        } completion:^(BOOL finished) {
            domain.histroiSettingView.hidden = YES;
        }];
    };
    
    [main.window addSubview:self.histroiSettingView];
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
            
            if (self.dataSource.count > 0) {
              NSMutableDictionary *caulDic = [self calculationAppears:self.dataSource];
            NSMutableArray *caulArr = [self calculationYiLou:self.dataSource];
                NSMutableArray *advYL = [self calculationPinJunYL:self.dataSource];
                //最大连击
                NSMutableArray *bigLJ = [self calculationAppearsLJ:self.dataSource];
                //剩余开奖时间
                AppDelegate *main = [UIApplication sharedApplication].delegate;
                NSString *currentTime = main.currentTime;
                NSString *secStr = [[currentTime componentsSeparatedByString:@":"] firstObject];
                NSString *mecStr = [[currentTime componentsSeparatedByString:@":"] lastObject];
                [self.dataSource addObject:@(secStr.intValue * 60 + mecStr.intValue)];
                //出现次数
                [self.dataSource addObject:caulDic];
                //最大遗漏
                [self.dataSource addObject:caulArr];
                //平均遗漏
                [self.dataSource addObject:advYL];
                //最大连击
                [self.dataSource addObject:bigLJ];
                
            }
            [self.historyTableView reloadData];
            [self.historyTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
            if (self.dataSource.count == 0) {
                [DZUtile showAlertViewWithMessage:@"暂无数据"];
                return;
            }
        }
    } requestFaile:^(NSString *result) {
        
    }];
}

//分析软件
- (void)anlyesController{
    AnlyesSoftwarsViewController *anlyes = [self.storyboard instantiateViewControllerWithIdentifier:@"AnlyesSoftwarsViewController"];
    [self.navigationController pushViewController:anlyes animated:YES];
}

//投注
- (void)buyNowAction:(NSArray *)selectedNumbers totalCount:(int)totalCount{
    NSDictionary *playDic = [[DZAllCommon shareInstance].currentLottyKind.plays lastObject];
    NSString *principal = playDic[@"principal"];
  
    DZShouldBuyViewController *shouldBuy = [self.storyboard instantiateViewControllerWithIdentifier:@"DZShouldBuyViewController"];
    shouldBuy.money = [NSString stringWithFormat:@"%.2f",totalCount * principal.floatValue];
    shouldBuy.isLookResult = NO;
    shouldBuy.totalCount = [NSString stringWithFormat:@"%d",totalCount];
    shouldBuy.selectedArr = @[selectedNumbers];
    shouldBuy.howMoney = principal;
    [self.navigationController pushViewController:shouldBuy animated:YES];
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
    DZHistoricalTrendCell *cell = [tableView dequeueReusableCellWithIdentifier:DZHistoricalTrendCell_Indentify forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

//设置
- (IBAction)showSetting:(UIButton *)sender {
    [self.actionSheet showInView:self.view];
}

- (void)configureCell:(DZHistoricalTrendCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    if (indexPath.row == self.dataSource.count-5) {
        //剩余开奖时间
        [cell initLabelsWithLowShowWinNumber:self.dataSource[indexPath.row]];
    }else if (indexPath.row == self.dataSource.count-4) {
        //出现次数
        [cell initLabelsWithAppears:self.dataSource[indexPath.row]];
    }else if (indexPath.row == self.dataSource.count-3) {
        //最大遗漏
        [cell initLabelsWithYL:self.dataSource[indexPath.row]];
    }else if (indexPath.row == self.dataSource.count-2) {
        //平均遗漏
        [cell initLabelsWithAdv:self.dataSource[indexPath.row]];
    }else if (indexPath.row == self.dataSource.count-1) {
        //最大连击
        [cell initLabelsWithBigLJ:self.dataSource[indexPath.row]];
    }else{
        //其他
        DZLastWinNumberRespond *respond = self.dataSource[indexPath.row];
        [cell initLabels:indexPath winNum:respond];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    UIColor *headerViewColor = COLOR(240, 240, 240);
    headerView.backgroundColor = headerViewColor;
    
    UIColor *color = COLOR(200, 200, 200);
    for (int i = 0; i < 12; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i * _rowHight , 0, _rowHight - 1, 43)];
        lab.backgroundColor = color;
        lab.numberOfLines = 0;
        lab.text = [NSString stringWithFormat:@"%d",i];
        lab.font = [UIFont systemFontOfSize:12.0f];
        lab.textColor = [UIColor lightGrayColor];
        lab.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            lab.text = @"期号";
        }
        [headerView addSubview:lab];
    }
    return headerView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (!self.footView) {
        self.footView = [[[NSBundle mainBundle] loadNibNamed:@"DZHistoricalBottomView" owner:self options:nil] firstObject];
    }
    __weak HistoricalTrendViewController *main = self;
    self.footView.btnSelected = ^(int tag,NSMutableArray *selectedNumbers,int totalCount){
        if (tag == 100) {
            //分析
            [main anlyesController];
        }else if(tag == 101){
            //投注
            if (selectedNumbers.count < 5) {
                [DZUtile showAlertViewWithMessage:@"最少选择5个数字"];
                return ;
            }
            [main buyNowAction:selectedNumbers totalCount:totalCount];
        }
    };
    return self.footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _rowHight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
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

//求最大遗漏
-(NSMutableArray *)calculationYiLou:(NSArray *)dataSource{
    NSArray *constNumbers = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11"];
    NSMutableArray *calculationYLArres = [[NSMutableArray alloc] init];
    for (NSString *num in constNumbers) {
        int max = 0;
        int oldLoaction = 0;
        for (int i = 1; i <= dataSource.count; i++) {
            DZLastWinNumberRespond *respond = dataSource[i-1];
            NSString *numbers = respond.numbers;
            if ([numbers containsString:num]) {

                if(i - oldLoaction > max){
                    max = i - oldLoaction;
                }
                oldLoaction = i;
            }
        }
        [calculationYLArres addObject:@(max-1)];
    }
    return calculationYLArres;
}

//求平均遗漏
-(NSMutableArray *)calculationPinJunYL:(NSArray *)dataSource{
    NSMutableDictionary *calculationDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *calculationPJYL = [[NSMutableArray alloc] init];
    NSArray *constNumbers = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11"];
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
    
    for (NSString *num in constNumbers) {
        NSNumber *numValue = @(num.intValue);
        NSMutableArray *numbers = calculationDic[numValue];
       int adv = (int)(dataSource.count - numbers.count) / (numbers.count+1);
        [calculationPJYL addObject:@(adv)];
    }
    
    return calculationPJYL;
}

//求最大连击
-(NSMutableArray *)calculationAppearsLJ:(NSArray *)dataSource{
    NSArray *constNumbers = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11"];

    NSMutableArray *mArr = [NSMutableArray array];

    for (NSString *num in constNumbers) {
        NSMutableArray *calculationYLArres = [[NSMutableArray alloc] init];
        for (int i = 0; i < dataSource.count; i++) {
            DZLastWinNumberRespond *respond = dataSource[i];
            NSString *numbers = respond.numbers;
            if ([numbers containsString:num]) {
                [calculationYLArres addObject:@(i)];
            }
        }
        
        int max = 0;
        int olMax = 0;
        for (NSNumber *nu in calculationYLArres) {
            if ([calculationYLArres containsObject:@(nu.intValue - 1)] || [calculationYLArres containsObject:@(nu.intValue + 1)]) {
                
                if (![calculationYLArres containsObject:@(nu.intValue - 1)] && [calculationYLArres containsObject:@(nu.intValue + 1)]) {
                    if (max > olMax) {
                        olMax = max;
                    }
                    max = 1;
                }else{
                    max ++;
                }
            }else{
                if (max > olMax) {
                    olMax = max;
                }
                max = 0;
            }
        }
        if (max > olMax) {
            olMax = max;
        }
        [mArr addObject:@(olMax)];
    }
    return mArr;
}

#pragma mark--UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        self.lastRequest.pageCount = 20;
    }else if (buttonIndex == 1){
          self.lastRequest.pageCount = 50;
    }else if (buttonIndex == 2){
        self.lastRequest.pageCount = 100;
    }else if (buttonIndex == 3){
        self.lastRequest.pageCount = 200;
    }else if (buttonIndex == 4){
        self.lastRequest.pageCount = 300;
    }else{
        return;
    }
    [self refreash];
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
