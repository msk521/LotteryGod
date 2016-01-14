//
//  AnlyesSoftwarsViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/6.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "AnlyesSoftwarsViewController.h"
#import "DZAnylesLHGJ_View.h"
#import "DZAnylersLTFW_View.h"
#import "DZAnlyersPHZS_View.h"
#import "DZMoreAnlyesView.h"
#import "DZBaseRequestModel.h"
#import "DZRequest.h"
#import "DZAnlyesRespond.h"
#import "DZAnlyesOtherView.h"
#import "DZAnlyers_DM.h"
#import "DZAnlyesSelectedRespond.h"
#import "DZSelectedCellTableViewCell.h"
#import "DZLookResultViewController.h"
#import <NSDictionary+RequestEncoding.h>
static NSString *const DZSelectedCellTableViewCell_Indentify = @"DZSelectedCellTableViewCell";
typedef enum {
    AnlyesType_LTFW,//龙头凤尾
    AnlyesType_PHZS,//平衡指数
    AnlyesType_LHGJ,//连号轨迹
    AnlyesType_BLH,//边临和
    AnlyesType_FBQJL,//反边球距离
    AnlyesType_ZDLMKD,//最大临码跨度
    AnlyesType_KU,//跨度
    AnlyesType_LMH, //临码和
    AnlyesType_Other//其他分析方式
}AnlyesType;
@interface AnlyesSoftwarsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topButtonsBackView;
//龙头凤尾
@property (nonatomic,strong) DZAnylersLTFW_View *ltfwView;
//平衡指数
@property (nonatomic,strong) DZAnlyersPHZS_View *phzsView;
//连号轨迹
@property (nonatomic,strong) DZAnylesLHGJ_View *lhgjView;
//其他分析类型
@property (nonatomic,strong) DZAnlyesOtherView *otherView;
@property (nonatomic,strong) DZAnlyers_DM *danmaView;
//更多
@property (nonatomic,strong) DZMoreAnlyesView *moreAnlyesView;
//分析结果总体情况
@property (weak, nonatomic) IBOutlet UILabel *anlyesTotalResult;
//分析项
@property (nonatomic,strong) NSMutableArray *dataSource;
//已选分析项
@property (nonatomic,strong) NSMutableArray *haveSelectedSource;
//执行过滤
@property (nonatomic,strong) NSMutableDictionary *searchResultDic;
//查看结果
@property (nonatomic,strong) NSMutableArray *lookResult;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation AnlyesSoftwarsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[NSMutableArray alloc] init];
    self.haveSelectedSource = [[NSMutableArray alloc] init];
    self.searchResultDic = [[NSMutableDictionary alloc] init];
    self.lookResult = [[NSMutableArray alloc] init];
    [self initAnlyesView];
    DZBaseRequestModel *request = [[DZBaseRequestModel alloc] init];
    request.requestApi = [DZAllCommon shareInstance].currentLottyKind.judgers;
    [[DZRequest shareInstance] requestWithParamter:request requestFinish:^(NSDictionary *result) {
        if (result[@"result"]) {
            for (NSDictionary *dic in result[@"result"]) {
                DZAnlyesRespond *respond = [[DZAnlyesRespond alloc] initWithDic:dic];
                [self.dataSource addObject:respond];
            }
        }
    } requestFaile:^(NSString *result) {
        
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
        if (self.haveSelectedNumbers && self.searchDic) {
            self.haveSelectedSource = [[NSMutableArray alloc] initWithArray:self.haveSelectedNumbers copyItems:YES];
            self.searchResultDic = [[NSMutableDictionary alloc] initWithDictionary:self.searchDic copyItems:YES];
            [self.tableview reloadData];
            //执行过滤结果
            [self doRequest:nil];
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initAnlyesView{
    self.otherView = [[[NSBundle mainBundle] loadNibNamed:@"DZAnlyesOtherView" owner:self options:nil] firstObject];
    self.moreAnlyesView = [[[NSBundle mainBundle] loadNibNamed:@"DZMoreAnlyesView" owner:self options:nil] firstObject];
    self.ltfwView = [[[NSBundle mainBundle] loadNibNamed:@"DZAnylersLTFW_View" owner:self options:nil] firstObject];
    self.phzsView = [[[NSBundle mainBundle] loadNibNamed:@"DZAnlyersPHZS_View" owner:self options:nil] firstObject];
    self.lhgjView = [[[NSBundle mainBundle] loadNibNamed:@"DZAnylesLHGJ_View" owner:self options:nil] firstObject];
    self.danmaView = [[[NSBundle mainBundle] loadNibNamed:@"DZAnlyers_DM" owner:self options:nil] firstObject];
    self.moreAnlyesView.hidden = YES;
    __weak AnlyesSoftwarsViewController *main = self;
    self.moreAnlyesView.hiddenView = ^(){
        
    [UIView animateWithDuration:0.5f animations:^{
            main.moreAnlyesView.alpha = 0.0;
        } completion:^(BOOL finished) {
            main.moreAnlyesView.frame = CGRectMake(0, -main.moreAnlyesView.frame.size.height, main.moreAnlyesView.frame.size.width, main.moreAnlyesView.frame.size.height);
            main.moreAnlyesView.hidden = YES;
        }];
    };
    self.moreAnlyesView.selectedAnlyes = ^(UIButton *sender){
        [main selectedAnlyesType:sender];
    };
    [self.view addSubview:self.moreAnlyesView];
}

//选择分析类型
- (IBAction)selectedAnlyesType:(UIButton *)sender {
   __weak DZAnylesView *anlysView;
    switch (sender.tag - 100) {
        case AnlyesType_LTFW:
            //龙头凤尾
        {
            NSString *title = @"龙头凤尾";
            DZAnlyesRespond *respond = [self searchRespond:title];
            NSString *selectedValue = [self searchHaveSelectedStr:title];
           
            [self.ltfwView replay:respond selectedNumber:selectedValue];
            anlysView = self.ltfwView;
        }
            break;
        case AnlyesType_PHZS:
            //平衡指数
        {
             NSString *title = @"平衡指数";
            DZAnlyesRespond *respond = [self searchRespond:title];
            NSString *selectedValue = [self searchHaveSelectedStr:title];
            
            [self.phzsView replay:respond selectedNumber:selectedValue];
            anlysView = self.phzsView;
        }
            break;
        
        case AnlyesType_LHGJ:
            //连号轨迹
        {
            NSString *title = @"连号轨迹";
            DZAnlyesRespond *respond = [self searchRespond:title];
            NSString *selectedValue = [self searchHaveSelectedStr:title];

            [self.lhgjView replay:respond selectedNumber:selectedValue];
            anlysView = self.lhgjView;
        }
            break;

        default:
        {
            //其他分析类型
            NSString *name;
            switch (sender.tag) {
                    
                case 108+8:
                    name = @"边临和";
                    break;
                case 104:
                    name = @"反边球距离";
                    break;
                case 105:
                    name = @"最大临码跨距";
                    break;
                case 106:
                    name = @"跨度";
                    break;
                case 107:
                    name = @"临码和";
                    break;
                case 108:
                    name = @"和值";
                    break;
                case 108+1:
                    name = @"连号个数";
                    break;
                case 108+2:
                    name = @"小数个数";
                    break;
                case 108+3:
                    name = @"大数个数";
                    break;
                case 108+4:
                    name = @"奇数个数";
                    break;
                case 108+5:
                    name = @"偶数个数";
                    break;
                case 108+6:
                    name = @"质数个数";
                    break;
                case 108+7:
                    name = @"合数个数";
                    break;
                case 103:
                    name = @"胆码";
                    break;
                default:
                    break;
            }
            DZAnlyesRespond *respond = [self searchRespond:name];
            if (sender.tag == 103) {
                //胆码
                NSString *selectedValue = [self searchHaveSelectedStr:name];
                
                [self.danmaView replayDM:respond selectedNumber:selectedValue];
            }else if(sender.tag == 108){
                NSString *selectedValue = [self searchHaveSelectedStr:name];
                
                [self.otherView replayHZ:respond selectedNumber:selectedValue];
            }else{
                NSString *selectedValue = [self searchHaveSelectedStr:name];
                [self.otherView replay:respond selectedNumber:selectedValue];
            }
                anlysView = self.otherView;
            if (sender.tag == 103) {
                anlysView = self.danmaView;
            }
        }
            break;
    }
    
    if (anlysView) {
        if (anlysView.hidden) {
            anlysView.hidden = NO;
            CGAffineTransform newTransform =
            CGAffineTransformScale(anlysView.transform, 0.1, 0.1);
            anlysView.transform = newTransform;
            anlysView.center = self.view.center;
            [UIView animateWithDuration:0.5f animations:^{
                CGAffineTransform ntransform = CGAffineTransformConcat(anlysView.transform,CGAffineTransformInvert(anlysView.transform));
                anlysView.transform = ntransform;
                anlysView.alpha = 1.0;
                anlysView.center = self.view.center;
            } completion:^(BOOL finished) {
                
            }];
        }
        anlysView.selectedDic = ^(NSString *jsonPath,NSString *name,NSString *selected){
            NSLog(@"path:%@   %@  %@",jsonPath,name,selected);
            if (!selected) {
                return ;
            }
            DZAnlyesSelectedRespond *selectedRespond = [[DZAnlyesSelectedRespond alloc] init];
            selectedRespond.selected = YES;
            selectedRespond.selectedName = name;
            selectedRespond.commitParamter = jsonPath;
            selectedRespond.commintValue = selected;
            if ([anlysView isKindOfClass:[DZAnylersLTFW_View class]]) {
                //如果是龙头凤尾
                DZAnylersLTFW_View *ltfwView = (DZAnylersLTFW_View *)anlysView;
                selectedRespond.ltfwValue = ltfwView.selectedName;
            }else if ([anlysView isKindOfClass:[DZAnlyersPHZS_View class]]){
                DZAnlyersPHZS_View *phzsView = (DZAnlyersPHZS_View *)anlysView;
                selectedRespond.phzsValue = phzsView.phzsNames;
            }else if ([anlysView isKindOfClass:[DZAnylesLHGJ_View class]]){
                DZAnylesLHGJ_View *lhgjView = (DZAnylesLHGJ_View *)anlysView;
                selectedRespond.phzsValue = lhgjView.lhgjName;
            }else if (sender.tag == 103){
                //胆码
                NSString *commtValue = [selected stringByReplacingOccurrencesOfString:@"danmaCount" withString:@""];
                commtValue = [commtValue stringByReplacingOccurrencesOfString:@"danma" withString:@""];
                selectedRespond.commintValue = [selected stringByReplacingOccurrencesOfString:@"&" withString:@","];
                selectedRespond.danmaValue = commtValue;
            }
            [self.searchResultDic setObject:selected forKey:[[jsonPath componentsSeparatedByString:@"."] lastObject]];

            [self.haveSelectedSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                DZAnlyesSelectedRespond *respon = obj;
                if ([respon.selectedName isEqualToString:name]) {
                    *stop = YES;
                    if (*stop == YES) {
                        [self.haveSelectedSource removeObjectAtIndex:idx];
                    }
                }
            }];
            
            if (selectedRespond.danmaValue && selectedRespond.danmaValue.length > 0) {
                //胆码1
                //显示
                NSString *danmeCommitValue = selectedRespond.danmaValue;
                NSArray *danmas = [danmeCommitValue componentsSeparatedByString:@"|"];
                //提交
                NSString *danmeCommitsValue = selectedRespond.commintValue;
                NSArray *danmasCom = [danmeCommitsValue componentsSeparatedByString:@"|"];
                
                [self.haveSelectedSource filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    DZAnlyesSelectedRespond *danma = (DZAnlyesSelectedRespond *)evaluatedObject;
                    if ([danma.selectedName isEqualToString:selectedRespond.selectedName]) {
                        return NO;
                    }
                    return YES;
                }]];
                
                for (int i = 0;i < danmas.count;i++) {
                    NSString *danmaValue = danmas[i];
                    DZAnlyesSelectedRespond *danma1 = [[DZAnlyesSelectedRespond alloc] init];
                    danma1.danmaValue = danmaValue;
                    danma1.selectedName = selectedRespond.selectedName;
                    danma1.tempDanma = danmasCom[i];
                    danma1.commintValue = selectedRespond.commintValue;
                    danma1.selected = selectedRespond.selected;
                    danma1.commitParamter = selectedRespond.commitParamter;
                    
                    [self.haveSelectedSource addObject:danma1];
                    
                }
              
            }else{
                
                [self.haveSelectedSource addObject:selectedRespond];
            }
            
            [self.tableview reloadData];
            //执行过滤结果
            [self doRequest:nil];
        };
    }
}

-(void)goBack:(id)sender{
    [super goBack:sender];
    self.moreAnlyesView.hidden = YES;
    [self.moreAnlyesView removeFromSuperview];
}

-(DZAnlyesRespond *)searchRespond:(NSString *)name{

    for (DZAnlyesRespond *respond in self.dataSource) {
        if ([respond.name isEqualToString:name]) {
            return respond;
        }
    }
    return nil;
}
//根据名称查询
-(NSString *)searchHaveSelectedStr:(NSString *)title{
    for (DZAnlyesSelectedRespond *respon in self.haveSelectedSource) {
        if ([respon.selectedName isEqualToString:title]) {
             return respon.commintValue;
        }
    }
    return nil;
}

//执行过滤
- (IBAction)doRequest:(UIButton *)sender {
    if (self.receivePreResult) {
        self.receivePreResult([self.haveSelectedSource copy],[self.searchResultDic copy],[self.lookResult copy]);
    }
    [self.searchResultDic removeAllObjects];
    for (DZAnlyesSelectedRespond *respon in self.haveSelectedSource) {
        if (respon.selected) {
            [self.searchResultDic setObject:respon.commintValue forKey:[[respon.commitParamter componentsSeparatedByString:@"."] lastObject]];
        }
    }
    NSString *requestApi = [DZAllCommon shareInstance].currentLottyKind.judge;
    //过滤接口
    NSDictionary *commitDic = [NSDictionary dictionaryWithObjectsAndKeys:requestApi,REQUEST_WEB_API,[self.searchResultDic jsonEncodedKeyValueString],@"conditions", nil];
    [[DZRequest  shareInstance] requestWithPDictionaryaramter:commitDic requestFinish:^(NSDictionary *result) {
        NSDictionary *resultDic = result[@"result"];
        self.anlyesTotalResult.text = [NSString stringWithFormat:@"共过滤到:%@注",resultDic[@"count"]];
        [self.lookResult removeAllObjects];
        [self.lookResult addObjectsFromArray:resultDic[@"list"]];
    } requestFaile:^(NSString *result) {
        
    }];
}


//查看结果
- (IBAction)lookResult:(UIButton *)sender {
    DZLookResultViewController *result = [self.storyboard instantiateViewControllerWithIdentifier:@"DZLookResultViewController"];
    result.searchResultArr = self.lookResult;
    [self.navigationController pushViewController:result animated:YES];
}

//查看更多
- (IBAction)lookMore:(UIButton *)sender {
     self.moreAnlyesView.alpha = 1.0;
    self.moreAnlyesView.frame = CGRectMake(self.topButtonsBackView.frame.origin.x, self.topButtonsBackView.frame.origin.y-99, self.topButtonsBackView.frame.size.width, (self.topButtonsBackView.frame.size.height + 99));
    [self.view bringSubviewToFront:self.moreAnlyesView];
    CGRect rect = self.moreAnlyesView.frame;
    rect.origin.y += rect.size.height-1;
    self.moreAnlyesView.hidden = NO;

    [UIView animateWithDuration:0.3f animations:^{
        self.moreAnlyesView.frame = rect;
    }];
}

//清空
- (IBAction)cleanData:(id)sender {
    self.anlyesTotalResult.text = @"";
    [self.haveSelectedSource removeAllObjects];
    [self.tableview reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.haveSelectedSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZSelectedCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DZSelectedCellTableViewCell_Indentify forIndexPath:indexPath];
    __weak AnlyesSoftwarsViewController *main = self;
    cell.deleteData = ^(){
        if (main.haveSelectedSource[indexPath.row]) {
            DZAnlyesSelectedRespond *selectedRespond = main.haveSelectedSource[indexPath.row];
            if ([selectedRespond.selectedName isEqualToString:@"胆码"]) {

            NSString *commitValue = self.searchResultDic[[[selectedRespond.commitParamter componentsSeparatedByString:@"."] lastObject]];
            NSString *temp = [NSString stringWithFormat:@"%@|",selectedRespond.tempDanma];
            
              NSString *nCommitValue = @"";
            if ([commitValue rangeOfString:temp].location != NSNotFound) {
               nCommitValue = [commitValue stringByReplacingCharactersInRange:[commitValue rangeOfString:temp] withString:@""];
                [self.searchResultDic setObject:nCommitValue forKey:[[selectedRespond.commitParamter componentsSeparatedByString:@"."] lastObject]];
            }else if (selectedRespond.tempDanma&&[commitValue rangeOfString:selectedRespond.tempDanma].location != NSNotFound) {
                nCommitValue = [commitValue stringByReplacingCharactersInRange:[commitValue rangeOfString:selectedRespond.tempDanma] withString:@""];
                [self.searchResultDic setObject:nCommitValue forKey:[[selectedRespond.commitParamter componentsSeparatedByString:@"."] lastObject]];
            }
                
                for (DZAnlyesSelectedRespond *respond in main.haveSelectedSource) {
                    if (respond.danmaValue && respond.danmaValue.length > 0) {
                        respond.commintValue = nCommitValue;
                    }
                }
            }
        }
        [main.haveSelectedSource removeObjectAtIndex:indexPath.row];
        if (self.haveSelectedNumbers) {
            
        }
        [main.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self doRequest:nil];
        [main.tableview reloadData];
     };
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(DZSelectedCellTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZAnlyesSelectedRespond *respon = self.haveSelectedSource[indexPath.row];
    [cell repaly:respon];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54.0f;
}

@end
