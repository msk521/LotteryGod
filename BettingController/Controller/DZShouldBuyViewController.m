//
//  DZShouldBuyViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/27.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZShouldBuyViewController.h"
#import "DZCharge.h"
#import <NSDictionary+RequestEncoding.h>
#import <Pingpp.h>
#import "DZSeniorChaseNumberViewController.h"
#import "DZBuySuccessViewController.h"
@interface DZShouldBuyViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *dataSource;
//投注情况
@property (weak, nonatomic) IBOutlet UILabel *selectedInfo;
@end

@implementation DZShouldBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        NSArray *reslut;
        if (self.isLookResult) {
            reslut = self.selectedArr;
        }else{
            if (self.selectedArr[0] && [self.selectedArr[0] count] == 5) {
                NSArray *arr = self.selectedArr[0];
                reslut = @[[arr componentsJoinedByString:@","]];
            }else{
                reslut = [self mySelectedNumberWithNum:self.selectedArr[0]];
            }
        }
        _dataSource = [[NSMutableArray alloc] initWithArray:reslut];
        self.selectedInfo.text = [NSString stringWithFormat:@"1倍*1期*%d注*%d元",(int)_dataSource.count,(int)_dataSource.count*[self.howMoney intValue]];
    }
    return _dataSource;
}

//购买
- (IBAction)shouldBuy:(UIButton *)sender {
    if (!self.selectedArr || self.selectedArr.count == 0) {
        [DZUtile showAlertViewWithMessage:@"请选择要投注的号码"];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定投注？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


//投注
-(void)buyLottery{
    NSDictionary *playDic = [[DZAllCommon shareInstance].currentLottyKind.plays lastObject];
    NSString *lotteryId = [DZAllCommon shareInstance].currentLottyKind.id;
    NSString *lotteryPlayId = playDic[@"id"];
    NSMutableArray *shoulArr = [[NSMutableArray alloc] init];
    NSArray *numbers;
    NSString *buyNumbers;
    if (self.isLookResult) {
        numbers = self.selectedArr;
        for (NSString *str in self.selectedArr) {
            [shoulArr addObject:@{@"lotteryNumbers":str,@"lotteryPlayId":lotteryPlayId}];
        }
        
    }else{
        numbers = [self.selectedArr lastObject];
        buyNumbers = [numbers componentsJoinedByString:@","];
        [shoulArr addObject:@{@"lotteryNumbers":buyNumbers,@"lotteryPlayId":lotteryPlayId}];
    }
    NSDictionary *lotteryNUmbers = @{@"multiple":@"1",@"detailNumbers":shoulArr};
    NSDictionary *resultDic = @{@"account":[DZAllCommon shareInstance].userInfoMation.account,@"details":@[lotteryNUmbers],@"lotteryId":lotteryId,@"pattern":@"1"};
    NSDictionary *commitDic = @{@"lotteryOrderInfo":[resultDic jsonEncodedKeyValueString],REQUEST_WEB_API:[DZAllCommon shareInstance].allServiceRespond.lotteryOrderCreate};

    [[DZRequest shareInstance] requestWithPDictionaryaramter:commitDic requestFinish:^(NSDictionary *result) {
        NSLog(@"result:%@",result);
        
        if ([result[@"success"] intValue] == 1) {
            NSDictionary *resultDic = result[@"result"];
            DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
            userInfoMation.balance = resultDic[@"balance"];
            userInfoMation.score = resultDic[@"score"];
            [DZUtile saveData];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserBlance object:nil];
            
            DZBuySuccessViewController *successController = [self.storyboard instantiateViewControllerWithIdentifier:@"DZBuySuccessViewController"];
            [self.navigationController pushViewController:successController animated:YES];
        }else{
            [DZUtile showAlertViewWithMessage:result[@"errorMessage"]];
        }
        
    } requestFaile:^(NSString *error) {
        
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shouldCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *results = nil;
        if (self.isLookResult) {
            NSString *numberStr = self.dataSource[indexPath.row];
            results = [numberStr componentsSeparatedByString:@","];
        }else{
            if ([self.selectedArr[0] count] == 5) {
                NSString *numbers = self.dataSource[0];
                results = [numbers componentsSeparatedByString:@","];
            }else{
                results = self.dataSource[indexPath.row];
            }
        }

        NSArray *resultArr = results;
        
        // 处理耗时操作的代码块...
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:100];
        UIImageView *imageView1 = (UIImageView *)[cell.contentView viewWithTag:101];
        UIImageView *imageView2 = (UIImageView *)[cell.contentView viewWithTag:102];
        UIImageView *imageView3 = (UIImageView *)[cell.contentView viewWithTag:103];
        UIImageView *imageView4 = (UIImageView *)[cell.contentView viewWithTag:104];
        UILabel *moneyLab = (UILabel *)[cell.contentView viewWithTag:200];
        moneyLab.text = [NSString stringWithFormat:@"1注%@元",self.howMoney];
        UIButton *delButton = (UIButton *)[cell.contentView viewWithTag:201];
        [delButton setTitle:[NSString stringWithFormat:@"%d",(int)indexPath.row] forState:UIControlStateSelected];
        [delButton addTarget:self action:@selector(deleteSomeRow:) forControlEvents:UIControlEventTouchUpInside];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[resultArr[0] intValue]]];
            imageView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[resultArr[1] intValue]]];
            imageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[resultArr[2] intValue]]];
            imageView3.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[resultArr[3] intValue]]];
            imageView4.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",[resultArr[4] intValue]]];
        });
    });
}

//清空内容
- (IBAction)cleanAllDataSource:(id)sender {
    self.selectedInfo.text = @"0期*0注*0元";
    [self.dataSource removeAllObjects];
    [self.tableview reloadData];
}

//删除某一行
-(void)deleteSomeRow:(UIButton *)sender{
    NSString *str = [sender titleForState:UIControlStateSelected];
    int row = str.intValue;
  
    [self.dataSource removeObjectAtIndex:row];
    [self.tableview reloadData];
    self.selectedInfo.text = [NSString stringWithFormat:@"1倍*1期*%d注*%d元",(int)_dataSource.count,(int)_dataSource.count*[self.howMoney intValue]];
}

-(NSArray *)mySelectedNumberWithNum:(NSArray *)number{
    NSMutableArray *allNumbers = [[NSMutableArray alloc] init];
    for (int i = 0; i < number.count; i++) {
        NSString *str = number[i];
        [allNumbers addObject:@(str.intValue)];
    }
    
    NSArray *results = [self combine:allNumbers m:5];
    return results;
}

-(NSArray *)combine:(NSArray *)start m:(int)m{
    NSInteger n = start.count;
    if (m > n) {
        NSLog(@"错误！数组a中只个元素小于m");
    }else{
        NSMutableArray *result = [[NSMutableArray alloc] init];
        NSMutableArray *bs = [[NSMutableArray alloc] initWithCapacity:n];
        for (int i = 0; i < n; i++) {
            bs[i] = @(0);
        }
        
        //初始化
        for(int i = 0;i < m;i++){
            bs[i] = @(1);
        }
        
        BOOL flag = YES;
        BOOL tempFlag = NO;
        int pos = 0;
        int sum = 0;
         //首先找到第一个10组合，然后变成01，同时将左边所有的1移动到数组的最左边
        do{
            sum = 0;
            pos = 0;
            tempFlag = YES;
            [result addObject:[self print:bs a:start m:m]];
            for (int i = 0; i < n -1; i++) {
                if ([bs[i] intValue] == 1 && [bs[i+1] intValue] == 0) {
                    bs[i] = @(0);
                    bs[i+1] = @(1);
                    pos = i;
                    break;
                }
            }
             //将左边的1全部移动到数组的最左边
            for (int i = 0; i < pos; i++) {
                if ([bs[i] intValue] == 1) {
                    sum++;
                }
            }
            
            for (int i = 0; i < pos; i++) {
                if (i < sum) {
                    bs[i] = @(1);
                }else{
                    bs[i] = @(0);
                }
            }
            //检查是否所有的1都移动到了最右边
            for (int i = (int)n - m ; i<n ; i++) {
                if ([bs[i] intValue] == 0) {
                    tempFlag = NO;
                    break;
                }
            }
            
            if (tempFlag == NO) {
                flag = YES;
            }else{
                flag = NO;
            }
        }while(flag);
        [result addObject:[self print:bs a:start m:m]];
        return result;
    }
    return nil;
}

-(NSMutableArray *)print:(NSArray *)bs a:(NSArray *)a m:(int)m{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    int pos = 0;
    for (int i = 0; i < bs.count; i++) {
        if ([bs[i] intValue] == 1) {
            result[pos] = a[i];
            pos++;
        }
    }
    return result;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.0f;
}

//高级追号
- (IBAction)seniorChaseNumber:(UIButton *)sender {
    
    DZSeniorChaseNumberViewController *seniorChaseNumberController = [self.storyboard instantiateViewControllerWithIdentifier:@"DZSeniorChaseNumberViewController"];
    seniorChaseNumberController.parent = @"1";
    seniorChaseNumberController.startBeiShu = @"1";
    seniorChaseNumberController.poids = @"1";
    seniorChaseNumberController.rate = @"1";
    seniorChaseNumberController.totalCount = self.totalCount.intValue;
    seniorChaseNumberController.totalMoney = [NSString stringWithFormat:@"%d",(int)self.howMoney.intValue * (int)self.dataSource.count];
    seniorChaseNumberController.selectedArr =_dataSource;
    [self.navigationController pushViewController:seniorChaseNumberController animated:YES];
}

#pragma mark--UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self buyLottery];
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
