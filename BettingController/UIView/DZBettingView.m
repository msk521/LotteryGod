//
//  DZBettingView.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/8.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBettingView.h"
#define KAIJIANG_TABLEVIEW 3
#define PLFive_TABLEVIEW   2
@implementation DZBettingView
-(id)init{
    self = [super init];
    if (self) {
        _shakeNumber = [[NSMutableArray alloc] initWithCapacity:0];
        //用户确定
        _makeSureSelectNumArray = [[NSMutableArray alloc] init];
        [self addTableview];
    }
    return self;
}

#pragma mark --
#pragma mark -- 添加选号cell

- (void)addTableview
{
    CGRect rect ;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        rect = CGRectMake(0, 70, 320, 433);
    }else{
        rect = CGRectMake(0, 70, 320, 405);
    }
  
    CGFloat with = [[UIScreen mainScreen] bounds].size.width;
    _PLFiveTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, with, 300) style:UITableViewStylePlain];
    _PLFiveTableView.tag = PLFive_TABLEVIEW;
    _PLFiveTableView.alpha = 1;
    _PLFiveTableView.dataSource = self;
    _PLFiveTableView.delegate = self;
    _PLFiveTableView.userInteractionEnabled = YES;
    _PLFiveTableView.bounces = YES;
    _PLFiveTableView.scrollEnabled = NO;
    _PLFiveTableView.showsHorizontalScrollIndicator = NO;
    _PLFiveTableView.showsVerticalScrollIndicator = NO;
    _PLFiveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _PLFiveTableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_PLFiveTableView];
}

- (void)pressedSureBut: (UIButton *)sender
{
    NSLog(@"确定");
    self._refreshData = NO;
    [_PLFiveTableView reloadData];
    for (NSInteger i = 0 ; i<5 ; i++ ) {
        NSMutableArray *tmpArr = [_makeSureSelectNumArray objectAtIndex:i];
        
        if ([tmpArr count] == 0) {
        }
    }
}


- (void)pressedClearBut: (UIButton *)sender
{
    NSLog(@"清空");
    self._refreshData = YES;
    [_shakeNumber removeAllObjects];
    [_PLFiveTableView reloadData];
    _numberNots.text = @"共0注";
    _totalMoney.text = @"0元";
    
}
#pragma mark --
#pragma mark -- tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 250;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellId = @"otherCell";
    DZNumberTableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[DZNumberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self._refreshData) {
            //摇手机出现的随机数
        [cell refreshDataWith:_shakeNumber];
        self._refreshData = NO;
    }
    [_makeSureSelectNumArray addObject:cell.selectNumberArray];
    cell.delegate = self;
    return cell;
}

#pragma mark --
#pragma mark -- NumberCellDelegate
//当前界面在选号时不可滑动，cell来控制
- (void)tableViewScrll:(BOOL)stop
{
    if (stop) {
        _PLFiveTableView.scrollEnabled = YES;
        NSLog(@"*****可滚动*****");
        
    }else
    {
        _PLFiveTableView.scrollEnabled = NO;
        NSLog(@"*****不可滚动*****");
        
    }
}

//选中或取消号码后产生的注数和钱数
- (void)getTotalNotsAndMoney
{
    NSDictionary *playDic = [[DZAllCommon shareInstance].currentLottyKind.plays lastObject];
    int principal = [playDic[@"principal"] intValue];
    NSInteger totalNumber = 1;
    [_PLFiveTableView reloadData];
   
    if (_makeSureSelectNumArray.count > 0) {
        NSMutableArray *tmpArray = [_makeSureSelectNumArray objectAtIndex:0];
        totalNumber *= [tmpArray count];
        if (totalNumber < 5) {
            return;
        }
        double tNum = [self jcWithNumber:totalNumber];
        double bNum = [self jcWithNumber:5];
        double nu = [self jcWithNumber:(totalNumber - 5)];
        int totalNumbers = tNum/(bNum * nu);
        if (self.selectedNumbs) {
            self.selectedNumbs(totalNumbers,totalNumbers*principal,_makeSureSelectNumArray);
        }
    }
}

-(double)jcWithNumber:(NSInteger)num{
    double totalNum = 1;
    int number = (int)num;
    for (int i = number; i >=1; i--) {
        totalNum *= i;
    }
    return (double)totalNum;
}

//检测到摇动
- (void)motionBeganing
{
    
    NSLog(@"检测到摇动");
    [_shakeNumber removeAllObjects];
    
    while (_shakeNumber.count != 5) {
        int j = arc4random()%11;
        if (j == 0) {
            j = 1;
        }
        NSString *selectNumStr = [NSString stringWithFormat:@"%d",j];
        if (![_shakeNumber containsObject:selectNumStr]) {
            [_shakeNumber addObject:selectNumStr];
        }
    }
    NSLog(@"*_shakeNumber:%@",_shakeNumber);
    
    [_PLFiveTableView reloadData];
}

//晃动结束
- (void)motionEnded
{
   
    
}

//任选多少位
-(void)selectedAnyNumbersWith:(int)num{
    [_shakeNumber removeAllObjects];
    if (num
         == 11) {
        for (int i = 1; i < 12; i++) {
            NSString *selectNumStr = [NSString stringWithFormat:@"%d",i];
                [_shakeNumber addObject:selectNumStr];
        }
        [_PLFiveTableView reloadData];
        return;
    }
    
    while (_shakeNumber.count != num) {
        int j = arc4random()%11;
        if (j == 0) {
            j = 1;
        }
        NSString *selectNumStr = [NSString stringWithFormat:@"%d",j];
        if (![_shakeNumber containsObject:selectNumStr]) {
            [_shakeNumber addObject:selectNumStr];
        }
    }
    NSLog(@"*_shakeNumber:%@",_shakeNumber);
    
    [_PLFiveTableView reloadData];
}

#pragma mark --
#pragma mark -- 清空
-(void)cleanAllSelected{
    self._refreshData = YES;
    self.selectedNumbs(0,0,_makeSureSelectNumArray);
    [_shakeNumber removeAllObjects];
    [_PLFiveTableView reloadData];
}

#pragma mark --
#pragma mark -- UISrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //取消所有点击小球的背景图
    for (UIView *tmpView in [UIApplication sharedApplication].delegate.window.subviews) {
        if (tmpView.tag == 123456) {
            [tmpView removeFromSuperview];
        }
    }
    
    self._refreshData = NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
