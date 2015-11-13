//
//  DZBuySuccessViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/11/10.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBuySuccessViewController.h"

@interface DZBuySuccessViewController ()

@end

@implementation DZBuySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//返回首页
- (IBAction)pooToRootController:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
