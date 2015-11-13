//
//  VKBaseViewController.m
//  OldManChat
//
//  Created by 马士奎 on 15/9/29.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import "DZBaseViewController.h"

@interface DZBaseViewController ()

@end

@implementation DZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.hud.labelText = @"正在加载⋯⋯";
    [self.view addSubview:self.hud];
    [self initData];
}


/**
 *  初始化设置全局数据
 */
-(void)initData{
    self.view.backgroundColor = COLOR(246.0f,241.0f,222.0f);
    [self initItemBar];
}

/**
 *  初始化数据
 */
-(void)initItemBar{

    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setTitle:@"信息" forState:UIControlStateNormal];
    UIBarButtonItem *letfBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(showPersonInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = letfBarButton;
}

-(IBAction)goBack:(id)sender{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
