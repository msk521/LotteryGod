//
//  DZAnlyers_DM.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/7.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZAnlyers_DM.h"
#import "DZDanMaTableViewCell.h"

static NSString *const DZDanMaTableViewCell_Indentify = @"DZDanMaTableViewCell";
@interface DZAnlyers_DM()<UITableViewDataSource,UITableViewDelegate>{
    __weak IBOutlet UIView *anlyesView;
    __weak IBOutlet UILabel *anlyesTiteName;
    NSArray *sourtedArr;
    NSDictionary *possibleValues;
    //已选
    NSMutableArray *selectedNumbers;
    NSMutableArray *selectedDanmaNumbers1;
    NSMutableArray *selectedDanmaNumbers2;
    NSMutableArray *selectedDanmaNumbers3;
    NSMutableArray *selectedDanmaNumbersCount1;
    NSMutableArray *selectedDanmaNumbersCount2;
    NSMutableArray *selectedDanmaNumbersCount3;
    DZAnlyesRespond *currentModel;

}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation DZAnlyers_DM

#pragma mark - UITableViewDataSource
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZDanMaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DZDanMaTableViewCell_Indentify forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(DZDanMaTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [cell replay:currentModel selectedNumbers:selectedDanmaNumbers1 danmacount:selectedDanmaNumbersCount1];
    }else if (indexPath.section == 1){
        [cell replay:currentModel selectedNumbers:selectedDanmaNumbers2 danmacount:selectedDanmaNumbersCount2];
    }else if (indexPath.section == 2){
        [cell replay:currentModel selectedNumbers:selectedDanmaNumbers3 danmacount:selectedDanmaNumbersCount3];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 40)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = [NSString stringWithFormat:@"胆码组%d",(int)section+1];
    [headerView addSubview:nameLabel];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

//胆码
-(void)replayDM:(DZAnlyesRespond *)model{
    selectedDanmaNumbers1 = [[NSMutableArray alloc] init];
    selectedDanmaNumbers2 = [[NSMutableArray alloc] init];
    selectedDanmaNumbers3 = [[NSMutableArray alloc] init];
    selectedDanmaNumbersCount1 = [[NSMutableArray alloc] init];;
    selectedDanmaNumbersCount2 = [[NSMutableArray alloc] init];;
    selectedDanmaNumbersCount3 = [[NSMutableArray alloc] init];;
    currentModel = model;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:DZDanMaTableViewCell_Indentify bundle:nil] forCellReuseIdentifier:DZDanMaTableViewCell_Indentify];
    [self.tableview reloadData];
}


//确认选择
- (IBAction)selectedShould:(UIButton *)sender {
    if (self.hiddenView) {
        self.hiddenView();
    }
    if (selectedDanmaNumbers1.count > 0 && selectedDanmaNumbersCount1.count > 0) {
        [selectedDanmaNumbers1 addObject:@"&"];
    }
        [selectedDanmaNumbers1 addObjectsFromArray:selectedDanmaNumbersCount1];
    if (selectedDanmaNumbers2.count > 0 && selectedDanmaNumbersCount2.count > 0) {
        [selectedDanmaNumbers2 addObject:@"&"];
    }
        [selectedDanmaNumbers2 addObjectsFromArray:selectedDanmaNumbersCount2];
    if (selectedDanmaNumbers3.count > 0 && selectedDanmaNumbersCount3.count > 0) {
        [selectedDanmaNumbers3 addObject:@"&"];
    }
        [selectedDanmaNumbers3 addObjectsFromArray:selectedDanmaNumbersCount3];
    
        NSString *numb1 = [selectedDanmaNumbers1 componentsJoinedByString:@","];

        NSString *numb2 = [selectedDanmaNumbers2 componentsJoinedByString:@","];
        NSString *numb3 = [selectedDanmaNumbers3 componentsJoinedByString:@","];
    
    if ([numb1 rangeOfString:@",&,"].location != NSNotFound) {
        numb1 = [numb1 stringByReplacingOccurrencesOfString:@",&," withString:@"&"];
    }
    
    if ([numb2 rangeOfString:@"&"].location != NSNotFound) {
       numb2 = [numb2 stringByReplacingOccurrencesOfString:@",&," withString:@"&"];
    }
    
    if ([numb3 rangeOfString:@"&"].location != NSNotFound) {
        numb3 = [numb3 stringByReplacingOccurrencesOfString:@",&," withString:@"&"];
    }
    
    self.selectedAnlyesPath = currentModel.flag;
    self.selectedAnlyesName = currentModel.name;
    
    NSMutableArray *selecteds = [[NSMutableArray alloc] init];
    if (numb1.length > 0) {
        [selecteds addObject:numb1];
    }
    if (numb2.length > 0) {
        [selecteds addObject:numb2];
    }
    if (numb3.length > 0) {
        [selecteds addObject:numb3];
    }
    
    self.selectedResult = [selecteds componentsJoinedByString:@"|"];
    
    if (self.selectedResult.length > 0) {
        self.selectedDic(self.selectedAnlyesPath,self.selectedAnlyesName,self.selectedResult);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
