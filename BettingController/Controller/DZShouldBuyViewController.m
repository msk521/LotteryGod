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
#import "DZPayMoneyViewController.h"
#import "AppDelegate.h"
@interface DZShouldBuyViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *tzButton;
@property (nonatomic,strong) NSMutableArray *dataSource;
//买多少期
@property (weak, nonatomic) IBOutlet UITextField *buyPoids;
//投多少倍
@property (weak, nonatomic) IBOutlet UITextField *buyBS;
//投注情况
@property (weak, nonatomic) IBOutlet UILabel *selectedInfo;
@property (nonatomic,assign) int keyBoardMargin_;
//投注倍数
@property (nonatomic,copy) NSString *tzBeishu;

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
        self.selectedInfo.text = [NSString stringWithFormat:@"%@倍*%@期*%d注*%d元",self.buyBS.text,self.buyPoids.text,(int)_dataSource.count,(int)_dataSource.count*[self.howMoney intValue]*[self.buyBS.text intValue]*[self.buyPoids.text intValue]];
    }
    return _dataSource;
}

//购买
- (IBAction)shouldBuy:(UIButton *)sender {
    [self.view endEditing:YES];
    if (!self.selectedArr || self.selectedArr.count == 0) {
        [DZUtile showAlertViewWithMessage:@"请选择要投注的号码"];
        return;
    }
    sender.enabled = NO;
    self.hud.labelText = @"正在投注...";
    [self.hud show:YES];
    [self buyLottery];
}


//投注
-(void)buyLottery{
    [self.view endEditing:YES];
    NSDictionary *playDic = [[DZAllCommon shareInstance].currentLottyKind.plays lastObject];
    NSString *lotteryId = [DZAllCommon shareInstance].currentLottyKind.id;
    NSString *lotteryPlayId = playDic[@"id"];
    NSMutableArray *shoulArr = [[NSMutableArray alloc] init];
    for (id selected in self.dataSource) {
        NSArray *shouldBuyArr = @[];
        if ([selected isKindOfClass:[NSString class]]) {

            shouldBuyArr = [selected componentsSeparatedByString:@","];
        }else{
           shouldBuyArr = selected;
        }
        NSMutableArray *shouldBuy = [NSMutableArray array];
        for (id numb in shouldBuyArr) {
            if ([numb isKindOfClass:[NSString class]]) {
                NSString *nNum = (NSString *)numb;
                if (nNum.intValue < 10) {
                    [shouldBuy addObject:[NSString stringWithFormat:@"0%d",nNum.intValue]];
                }else{
                    [shouldBuy addObject:[NSString stringWithFormat:@"%d",nNum.intValue]];
                }
            }else{
                [shouldBuy addObject:numb];
            }
        }
        [shoulArr addObject:@{@"lotteryNumbers":[shouldBuy componentsJoinedByString:@","],@"lotteryPlayId":lotteryPlayId}];
    }
    
    AppDelegate *main = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *selectedAnlyes = [main.selectedAnlyes allObjects];
    NSString *extension = [selectedAnlyes componentsJoinedByString:@";"];
    
    NSMutableArray *details = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.buyPoids.text intValue]; i++) {
        NSDictionary *lotteryNUmbers = @{@"multiple":self.buyBS.text,@"detailNumbers":shoulArr};
        [details addObject:lotteryNUmbers];
    }
    
    NSDictionary *resultDic = @{@"account":[DZAllCommon shareInstance].userInfoMation.account,@"details":details,@"lotteryId":lotteryId,@"pattern":@"1",@"autoCancelOrderWhenWinning":[NSNumber numberWithBool:YES],@"extension":extension};
    NSDictionary *commitDic = @{@"lotteryOrderInfo":[resultDic jsonEncodedKeyValueString],REQUEST_WEB_API:[DZAllCommon shareInstance].allServiceRespond.lotteryOrderCreate};
    [self.hud hide:YES];
    self.tzButton.enabled = YES;
    DZPayMoneyViewController *payMoney = [self.storyboard instantiateViewControllerWithIdentifier:@"DZPayMoneyViewController"];
    payMoney.buyInfo = self.selectedInfo.text;
    payMoney.shouldPayMoney = [NSString stringWithFormat:@"%d",(int)_dataSource.count*[self.howMoney intValue]*[self.buyBS.text intValue]*[self.buyPoids.text intValue]];
    payMoney.currentPoidPayMoney = self.currentPoids;
    payMoney.commitDic = commitDic;
    [self.navigationController pushViewController:payMoney animated:YES];
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
            
            if ([self.dataSource[indexPath.row] isKindOfClass:[NSArray class]]) {
                results = self.dataSource[indexPath.row];
            }else {
                NSString *numberStr = self.dataSource[indexPath.row];
                results = [numberStr componentsSeparatedByString:@","];
            }
        }else{
            results = self.dataSource[indexPath.row];
            if ([self.dataSource[indexPath.row] isKindOfClass:[NSString class]]) {
                results = [self.dataSource[indexPath.row] componentsSeparatedByString:@","];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

//清空内容
- (IBAction)cleanAllDataSource:(id)sender {
    [self.view endEditing:YES];
    self.selectedInfo.text = @"0期*0注*0元";
    [self.dataSource removeAllObjects];
    [self.tableview reloadData];
}

-(void)goBack:(id)sender{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

//删除某一行
-(void)deleteSomeRow:(UIButton *)sender{
    [self.view endEditing:YES];
    NSString *str = [sender titleForState:UIControlStateSelected];
    int row = str.intValue;
  
    [self.dataSource removeObjectAtIndex:row];
    [self.tableview reloadData];
    self.selectedInfo.text = [NSString stringWithFormat:@"%@倍*%@期*%d注*%d元",self.buyBS.text,self.buyPoids.text,(int)_dataSource.count,(int)_dataSource.count*[self.howMoney intValue]*[self.buyBS.text intValue]*[self.buyPoids.text intValue]];
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

//加5注
-(void)AddFiveallNumbers{
    if (self.dataSource.count > 462 - 5) {
        return;
    }
    NSArray *nums = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"];
    NSArray *results = [self combine:nums m:5];
    NSMutableArray *allSourt = [[NSMutableArray alloc] init];
    for (NSArray *arr in results) {
        [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSNumber *number1 = @([obj1 intValue]);
            NSNumber *number2 = @([obj2 intValue]);
            
            NSComparisonResult result = [number1 compare:number2];
            return result == NSOrderedDescending;
        }];
        [allSourt addObject:arr];
    }
    
    NSMutableArray *selectedAllSourt = [[NSMutableArray alloc] init];

        for (id numstr in self.dataSource) {
            NSString *numSelectedStr = @"";
            if ([numstr isKindOfClass:[NSString class]]) {
                numSelectedStr =  numstr;
            }else if([numstr isKindOfClass:[NSArray class]]){
                numSelectedStr = [numstr componentsJoinedByString:@","];
            }
            NSArray *arr = [numSelectedStr componentsSeparatedByString:@","];
            NSArray *resultArr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSNumber *number1 = @([obj1 intValue]);
                NSNumber *number2 = @([obj2 intValue]);
                
                NSComparisonResult result = [number1 compare:number2];
                return result == NSOrderedDescending;
            }];
            [selectedAllSourt addObject:resultArr];
        }

    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:selectedAllSourt];
    NSMutableSet *allSet = [NSMutableSet setWithArray:allSourt];
    NSSet *selectedSet = [NSSet setWithArray:self.dataSource];
    [allSet minusSet:selectedSet];
    if (allSet.count >= 5) {
        NSArray *allOther = [allSet allObjects];
        NSMutableArray *arcmArr = [[NSMutableArray alloc] init];
        while (arcmArr.count < 5) {
           int index = (int)(0 + (arc4random() % (allOther.count + 1)));
            [arcmArr addObject:@(index)];
        }
        for (int i =0; i < arcmArr.count; i++) {
            int indexPath = [arcmArr[i] intValue];
            if (!self.isLookResult) {
                NSArray *arrN = allOther[indexPath];
               [self.dataSource insertObject:[arrN componentsJoinedByString:@","] atIndex:0];
            }else{
                [self.dataSource insertObject:allOther[indexPath] atIndex:0];
            }
        }
    }
    [self.tableview reloadData];
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

//机选5注
- (IBAction)addFiveNumber:(id)sender {
    [self AddFiveallNumbers];
    self.selectedInfo.text = [NSString stringWithFormat:@"%@倍*%@期*%d注*%d元",self.buyBS.text,self.buyPoids.text,(int)_dataSource.count,(int)_dataSource.count*[self.howMoney intValue]*[self.buyBS.text intValue]*[self.buyPoids.text intValue]];
}

//高级追号
- (IBAction)seniorChaseNumber:(UIButton *)sender {
    
    DZSeniorChaseNumberViewController *seniorChaseNumberController = [self.storyboard instantiateViewControllerWithIdentifier:@"DZSeniorChaseNumberViewController"];
    seniorChaseNumberController.currentPoids = self.currentPoids;
    seniorChaseNumberController.parent = @"1";
    seniorChaseNumberController.startBeiShu = self.buyBS.text;
    seniorChaseNumberController.poids = self.buyPoids.text;
    seniorChaseNumberController.rate = @"1";
    seniorChaseNumberController.totalCount = (int)_dataSource.count;
    seniorChaseNumberController.totalMoney = [NSString stringWithFormat:@"%d",(int)_dataSource.count*[self.howMoney intValue]*[self.buyBS.text intValue]*[self.buyPoids.text intValue]];
    seniorChaseNumberController.selectedArr =_dataSource;
    [self.navigationController pushViewController:seniorChaseNumberController animated:YES];
}

//隐藏键盘
- (IBAction)hiddenKeyBoard:(UIButton *)sender {
    [self.view endEditing:YES];
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

#pragma mark - 解决键盘遮挡问题
- (void)moveView:(UITextField *)textField leaveView:(BOOL)leave
{
    float screenHeight = self.view.bounds.size.height
    ; //屏幕尺寸，如果屏幕允许旋转，可根据旋转动态调整
    float keyboardHeight = 210; //键盘尺寸，如果屏幕允许旋转，可根据旋转动态调整
    float statusBarHeight,NavBarHeight,tableCellHeight,textFieldOriginY,textFieldFromButtomHeigth;
    int margin = 0;
    statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height; //屏幕状态栏高度
    NavBarHeight = self.navigationController.navigationBar.frame.size.height; //获取导航栏高度
    
    UITableViewCell *tableViewCell=(UITableViewCell *)textField.superview;
    tableCellHeight = tableViewCell.frame.size.height; //获取单元格高度
    
    CGRect fieldFrame=[self.view convertRect:textField.frame fromView:tableViewCell];
    textFieldOriginY = fieldFrame.origin.y; //获取文本框相对本视图的y轴位置。
    
    //计算文本框到屏幕底部的高度（屏幕高度-顶部状态栏高度-导航栏高度-文本框的的相对y轴位置-单元格高度）
    textFieldFromButtomHeigth = screenHeight - statusBarHeight - NavBarHeight - textFieldOriginY - tableCellHeight;
    
    if(!leave) {
        if(textFieldFromButtomHeigth < keyboardHeight) { //如果文本框到屏幕底部的高度 < 键盘高度
            
            margin = keyboardHeight;//向上推键盘的高度
            
            self.keyBoardMargin_ = margin; //keyBoardMargin_ 为成员变量，记录上一次移动的间距,用户离开文本时恢复视图高度
        } else {
            margin= 0;
            self.keyBoardMargin_ = 0;
        }
    }
    const float movementDuration = 0.3f; // 动画时间
    
    int movement = (leave ? self.keyBoardMargin_ : -margin); //进入时根据差距移动视图，离开时恢复之前的高度
    
    [UIView animateWithDuration:movementDuration animations:^{
        [UIView setAnimationBeginsFromCurrentState: YES];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    } completion:^(BOOL finished) {
        
    }];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveView:textField leaveView:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    [self moveView:textField leaveView:YES];
    if (textField.text.intValue != 0) {
    self.selectedInfo.text = [NSString stringWithFormat:@"%@倍*%@期*%d注*%d元",self.buyBS.text,self.buyPoids.text,(int)_dataSource.count,(int)_dataSource.count*[self.howMoney intValue]*[self.buyBS.text intValue]*[self.buyPoids.text intValue]];
        return;
    }
    if (textField == self.buyBS && textField.text.intValue == 0) {
        textField.text = @"1";
         self.selectedInfo.text = [NSString stringWithFormat:@"%@倍*%@期*%d注*%d元",@"1",self.buyPoids.text,(int)_dataSource.count,(int)_dataSource.count*[self.howMoney intValue]*[self.buyBS.text intValue]*[self.buyPoids.text intValue]];
    }
    if (textField == self.buyPoids && textField.text.intValue == 0) {
        textField.text = @"1";
         self.selectedInfo.text = [NSString stringWithFormat:@"%@倍*%@期*%d注*%d元",self.buyBS.text,@"1",(int)_dataSource.count,(int)_dataSource.count*[self.howMoney intValue]*[self.buyBS.text intValue]*[self.buyPoids.text intValue]];
    }
}
//减期数
- (IBAction)minuPiods:(UIButton *)sender {
    if (self.buyPoids.text.intValue <= 1) {
        self.buyPoids.text = @"1";
    }else{
        self.buyPoids.text = [NSString stringWithFormat:@"%d",self.buyPoids.text.intValue - 1];
    }
    self.selectedInfo.text = [NSString stringWithFormat:@"%@倍*%@期*%d注*%d元",self.buyBS.text,self.buyPoids.text,(int)_dataSource.count,(int)_dataSource.count*[self.howMoney intValue]*[self.buyBS.text intValue]*[self.buyPoids.text intValue]];
}
//加期数
- (IBAction)addPiods:(UIButton *)sender {
    self.buyPoids.text = [NSString stringWithFormat:@"%d",self.buyPoids.text.intValue + 1];
    self.selectedInfo.text = [NSString stringWithFormat:@"%@倍*%@期*%d注*%d元",self.buyBS.text,self.buyPoids.text,(int)_dataSource.count,(int)_dataSource.count*[self.howMoney intValue]*[self.buyBS.text intValue]*[self.buyPoids.text intValue]];
}
//减倍数
- (IBAction)minuBS:(UIButton *)sender {
    if (self.buyBS.text.intValue <= 1) {
        self.buyBS.text = @"1";
    }else{
        self.buyBS.text = [NSString stringWithFormat:@"%d",self.buyBS.text.intValue - 1];
    }
    self.selectedInfo.text = [NSString stringWithFormat:@"%@倍*%@期*%d注*%d元",self.buyBS.text,self.buyPoids.text,(int)_dataSource.count,(int)_dataSource.count*[self.howMoney intValue]*[self.buyBS.text intValue]*[self.buyPoids.text intValue]];
}
//加倍数
- (IBAction)addBS:(UIButton *)sender {
    self.buyBS.text = [NSString stringWithFormat:@"%d",self.buyBS.text.intValue + 1];
    self.selectedInfo.text = [NSString stringWithFormat:@"%@倍*%@期*%d注*%d元",self.buyBS.text,self.buyPoids.text,(int)_dataSource.count,(int)_dataSource.count*[self.howMoney intValue]*[self.buyBS.text intValue]*[self.buyPoids.text intValue]];
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
