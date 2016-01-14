//
//  DZShowBuyDetailView.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/22.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZShowBuyDetailView.h"
#import "DZShowBuyDetailTableViewCell.h"
#import "DZOrderDetailNumberRequest.h"
static NSString *const DZShowBuyDetailTableViewCellIndentify = @"DZShowBuyDetailTableViewCell";
@interface DZShowBuyDetailView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) DZMyOrderListRespond *currentRespond;
@end
@implementation DZShowBuyDetailView

-(void)replay:(DZMyOrderListRespond *)respond{
    self.currentRespond = respond;
    [self.tableview registerNib:[UINib nibWithNibName:DZShowBuyDetailTableViewCellIndentify bundle:nil] forCellReuseIdentifier:DZShowBuyDetailTableViewCellIndentify];
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:respond.detailNumbers];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DZShowBuyDetailTableViewCellIndentify forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *buyNumber = (UILabel *)[cell viewWithTag:100];
    NSDictionary *dic = self.dataSource[indexPath.row];
    buyNumber.text = dic[@"lotteryNumbers"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGSize maxSize = CGSizeMake(self.bounds.size.width, 2000.f);
    CGSize newSize = DZ_Calculate_StringSize(self.currentRespond.extension, [UIFont systemFontOfSize:13.0f], maxSize, 0);
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,tableView.sectionHeaderHeight)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headView.frame.size.width-20, newSize.height + 20)];
    lab.font = [UIFont systemFontOfSize:13.0f];
    headView.backgroundColor = [UIColor whiteColor];
    if (!self.currentRespond.extension || self.currentRespond.extension.length == 0) {
            lab.text = @"分析方式:自选";
    }else{
        lab.text = [NSString stringWithFormat:@"分析方式:%@",self.currentRespond.extension];
    }

    lab.numberOfLines = 0;
    [headView addSubview:lab];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGSize maxSize = CGSizeMake(self.bounds.size.width, 2000.f);
    CGSize newSize = DZ_Calculate_StringSize(self.currentRespond.extension, [UIFont systemFontOfSize:13.0f], maxSize, 0);
    return newSize.height + 20;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
