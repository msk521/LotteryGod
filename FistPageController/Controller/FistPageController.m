//
//  FistPageController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/3.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "FistPageController.h"
#import "DZFPTopTableViewCell.h"
#import "DZFPOtherTableViewCell.h"
#import "DZShowChangeView.h"
#import "DZFPTop.h"
#import "AppDelegate.h"
#import "AnlyesSoftwarsViewController.h"
#import "DZBettingViewController.h"
#import "IncomeStatementViewController.h"
#import "InvitationGoodFriendViewController.h"
#import "DZSettingViewController.h"
#import "DZCoolAndHotNumController.h"
#import "DZLoginViewController.h"
#import "DZPersonInfoViewController.h"
#import "DZSettingViewController.h"
#import "DZUtile.h"
#import "DZLottyKindsRequest.h"
#import "DZRequest.h"
#import "DZLottyKindsRespond.h"
#import "DZLastWinNumberRespond.h"
#import "DZMyOrderListViewController.h"
#import "DZUserBalaceRequest.h"
typedef enum {
    FPStyle_Top,
    FPStyle_Other,
    FPStyleCount
}FPStyle;
@interface FistPageController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *fpTableView;
//选择城市
@property (nonatomic,strong) DZShowChangeView *changeView;
@property (nonatomic,strong) DZFPTop *fpTop;
@property (nonatomic,strong) DZLastWinNumberRespond *lstWinNum;
@property (nonatomic,strong) MZTimerLabel *currentTimerLabel;
@property (nonatomic,strong) NSMutableArray *citysData;
@property (weak, nonatomic) IBOutlet UIButton *kindName;

@end

static NSString *DZFPTopTableViewCell_Indentify = @"DZFPTopTableViewCell";
static NSString *DZFPOtherTableViewCell_Indentify = @"DZFPOtherTableViewCell";
@implementation FistPageController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestUserBalance];
    [self checkRequestLastNumber];
}

-(void)checkRequestLastNumber{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.shouldAgainRequestWinNumber && ![DZUtile checkTime]) {
        if (self.changeView) {
            [self.changeView requestCitys];
            [self.fpTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}
//获取用户金币数
-(void)requestUserBalance{
    
    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
    if (!userInfoMation.idNumber || !userInfoMation.idNumber.length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UserBlance object:nil];
        return;
    }
    
    DZUserBalaceRequest *request = [[DZUserBalaceRequest alloc] init];
    [[DZRequest shareInstance] requestWithParamter:request requestFinish:^(NSDictionary *result) {
        
        if (result[@"result"] && [result[@"success"] intValue] != 0) {
            NSDictionary *resultDic = result[@"result"];
            DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
            userInfoMation.balance = resultDic[@"balance"];
            userInfoMation.score = resultDic[@"score"];
            [DZUtile saveData];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserBlance object:nil];
        }
    } requestFaile:^(NSString *result) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restLottyKindName:) name:RESTLOTTYNAME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkRequestLastNumber) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self registTableviewCell];
    [self initChangeView];
}

//设置当前彩种名称
-(void)restLottyKindName:(NSNotification *)notify{
    DZLottyKindsRespond *current = [DZAllCommon shareInstance].currentLottyKind;
    [self.kindName setTitle:current.name forState:UIControlStateNormal];
}

//初始化选择城市框
-(void)initChangeView{
    if (self.changeView == nil) {
        AppDelegate *main = APPLICATION;
        __weak FistPageController *domain = self;
        self.changeView = [[[NSBundle mainBundle] loadNibNamed:@"DZShowChangeView" owner:self options:nil] firstObject];
        self.changeView.frame = CGRectMake(0, 0, main.window.bounds.size.width, main.window.bounds.size.height + 50);
        [self.changeView requestCitys];
        self.changeView.hidden = YES;
        self.changeView.alpha = 0.0f;
        [main.window addSubview:self.changeView];
        self.changeView.hiddenView = ^(){
            [UIView animateWithDuration:0.5f animations:^{
                CGAffineTransform ntransform = CGAffineTransformScale(domain.changeView.transform, 0.1, 0.1);
                domain.changeView.transform = ntransform;
                domain.changeView.alpha = 0.0;
                domain.changeView.center = domain.view.center;
            } completion:^(BOOL finished) {
                domain.changeView.hidden = YES;
            }];
        };
        
        self.changeView.showView = ^(DZLottyKindsRespond *respond){
            [domain.kindName setTitle:respond.name forState:UIControlStateNormal];
        };
        
        //改变彩种
        self.changeView.changeLottyKind = ^(DZLastWinNumberRespond *respond){
            domain.lstWinNum = respond;
            [domain.fpTableView reloadData];
        };
    }
}

//注册cell
-(void)registTableviewCell{
    [self.fpTableView registerNib:[UINib nibWithNibName:DZFPTopTableViewCell_Indentify bundle:nil] forCellReuseIdentifier:DZFPTopTableViewCell_Indentify];
    [self.fpTableView registerNib:[UINib nibWithNibName:DZFPOtherTableViewCell_Indentify bundle:nil] forCellReuseIdentifier:DZFPOtherTableViewCell_Indentify];
}

//检测是否已登录
- (IBAction)userLogin:(id)sender {
        DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
    if (!userInfoMation.idNumber || !userInfoMation.idNumber.length > 0) {
        DZLoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"DZLoginViewController"];
        [DZUtile showLoginViewController:loginView animation:YES finishLoading:^{
            
        } hiddenFinish:^{
            
        }];
    }else{
        DZPersonInfoViewController *personInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"DZPersonInfoViewController"];
        [self.navigationController pushViewController:personInfo animated:YES];
    }
}

- (IBAction)settingControlelr:(id)sender {
    DZSettingViewController *settingController = [self.storyboard instantiateViewControllerWithIdentifier:@"DZSettingViewController"];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return FPStyleCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==  FPStyle_Top) {
        DZFPTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DZFPTopTableViewCell_Indentify forIndexPath:indexPath];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        cell.currentTime = ^(MZTimerLabel *timer){
            self.currentTimerLabel = timer;
        };
        return cell;
    }else{
        DZFPOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DZFPOtherTableViewCell_Indentify forIndexPath:indexPath];
        cell.jumpToController = ^(int tag){
            switch (tag) {
                case 100:
                    //分析软件
                {
                    AnlyesSoftwarsViewController *anlyes = [self.storyboard instantiateViewControllerWithIdentifier:@"AnlyesSoftwarsViewController"];
                    [self.navigationController pushViewController:anlyes animated:YES];
                }
                    break;
                case 101:
                    //投注
                {
                    DZBettingViewController *betting = [self.storyboard instantiateViewControllerWithIdentifier:@"DZBettingViewController"];
                    betting.currentRespond =  self.lstWinNum;
                    NSString *currentTime = self.currentTimerLabel.timeLabel.text;
                    NSString *secStr = [[currentTime componentsSeparatedByString:@":"] firstObject];
                    NSString *mecStr = [[currentTime componentsSeparatedByString:@":"] lastObject];
                    
                    betting.resetTimer = secStr.intValue * 60 + mecStr.intValue;
                    [self.navigationController pushViewController:betting animated:YES];
                }
                    break;
                case 102:
                    //收支明细
                {
                    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
                    if (!userInfoMation.account || userInfoMation.account.length == 0) {
                        DZLoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"DZLoginViewController"];
                        [DZUtile showLoginViewController:loginView animation:YES finishLoading:^{
                            IncomeStatementViewController *incomeState = [self.storyboard instantiateViewControllerWithIdentifier:@"IncomeStatementViewController"];
                            [self.navigationController pushViewController:incomeState animated:YES];
                        }hiddenFinish:^{
                            
                        }];
                    }else{
                        IncomeStatementViewController *incomeState = [self.storyboard instantiateViewControllerWithIdentifier:@"IncomeStatementViewController"];
                        [self.navigationController pushViewController:incomeState animated:YES];
                    }
                }
                    break;
                case 103:
                    //邀请好友
                {
                    
                    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
                    if (!userInfoMation.account || userInfoMation.account.length == 0) {
                        DZLoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"DZLoginViewController"];
                        [DZUtile showLoginViewController:loginView animation:YES finishLoading:^{
                            InvitationGoodFriendViewController *itationGoodFriendViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InvitationGoodFriendViewController"];
                            [self.navigationController pushViewController:itationGoodFriendViewController animated:YES];
                        }hiddenFinish:^{
                            
                        }];
                    }else{
                        InvitationGoodFriendViewController *itationGoodFriendViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InvitationGoodFriendViewController"];
                        [self.navigationController pushViewController:itationGoodFriendViewController animated:YES];
                    }

                }
                    break;
                case 104:
                    //切换省份
                {
                    [self changeCity:nil];
                }
                    break;
                case 105:
                    //冷热数字
                {
                DZCoolAndHotNumController *coolAndHot = [self.storyboard instantiateViewControllerWithIdentifier:@"DZCoolAndHotNumController"];
                [self.navigationController pushViewController:coolAndHot animated:YES];
                }
                    break;
                case 106:
                    //我的方案
                {
                    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
                    if (!userInfoMation.account || userInfoMation.account.length == 0) {
                        DZLoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"DZLoginViewController"];
                        [DZUtile showLoginViewController:loginView animation:YES finishLoading:^{
                            DZMyOrderListViewController *order = [self.storyboard instantiateViewControllerWithIdentifier:@"DZMyOrderListViewController"];
                            [self.navigationController pushViewController:order animated:YES];
                        }hiddenFinish:^{
                            
                        }];
                    }else{
                        DZMyOrderListViewController *order = [self.storyboard instantiateViewControllerWithIdentifier:@"DZMyOrderListViewController"];
                        [self.navigationController pushViewController:order animated:YES];
                    }
                }
                    break;
                case 107:
                    //客户服务
                {
                    UIAlertView *showCall = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确认拨打客户电话400-1555-333吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
                    [showCall show];
                }
                    break;
                default:
                    break;
            }
        };
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
      if (indexPath.row ==  FPStyle_Top) {
          if (iPhone6) {
              return 250;
          }
          if (iPhone6Plus) {
              return 280;
          }
          return 212.0f;
      }else{
          if (iPhone6) {
              return 200;
          }
          if (iPhone6Plus) {
              return 230;
          }
          return 158.0f;
      }
}

//初始化topcell
- (void)configureCell:(DZFPTopTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.lstWinNum) {
      [cell replay:self.lstWinNum];
    }
}

//选择城市
- (IBAction)changeCity:(id)sender {
    if (self.changeView.hidden) {
        self.changeView.hidden = NO;
        CGAffineTransform newTransform =
        CGAffineTransformScale(self.changeView.transform, 0.1, 0.1);
        self.changeView.transform = newTransform;
        [UIView animateWithDuration:0.5f animations:^{
            CGAffineTransform ntransform = CGAffineTransformConcat(self.changeView.transform,CGAffineTransformInvert(self.changeView.transform));
            self.changeView.transform = ntransform;
            self.changeView.alpha = 1.0;
            self.changeView.center = self.view.center;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark-UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *telephone = @"";
        telephone = @"tel://4000-1344-1222";
        
        //这种方法  通话结束后返回 app
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telephone]]];
            [self.view addSubview:callWebview];
    }
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
