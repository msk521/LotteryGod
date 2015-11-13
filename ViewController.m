//
//  ViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/16.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = COLOR(255, 93, 0);
    UINavigationController *fistNav = [self.storyboard instantiateViewControllerWithIdentifier:@"FistPageControllerNav"];
    UITabBarItem *item1 = [[UITabBarItem alloc] init];
    item1.title = @"首页";
    item1.image = [[UIImage imageNamed:@"bottom_icon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.selectedImage = [[UIImage imageNamed:@"bottom_icon1-hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    fistNav.tabBarItem = item1;
    
    UINavigationController *secondNav = [self.storyboard instantiateViewControllerWithIdentifier:@"LotteryResultsViewControllerNav"];
    UITabBarItem *item2 = [[UITabBarItem alloc] init];
    item2.title = @"开奖结果";
    item2.image = [[UIImage imageNamed:@"bottom_icon2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"bottom_icon2-hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    secondNav.tabBarItem = item2;
    
    UINavigationController *thirdNav = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoricalTrendViewControllerNav"];
    UITabBarItem *item3 = [[UITabBarItem alloc] init];
    item3.title = @"历史走势";
    item3.image = [[UIImage imageNamed:@"bottom_icon3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"bottom_icon3-hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     thirdNav.tabBarItem = item3;
    
    UINavigationController *foureNav = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonInfoViewControllerNav"];
    UITabBarItem *item4 = [[UITabBarItem alloc] init];
    item4.title = @"个人中心";
    item4.image = [[UIImage imageNamed:@"bottom_icon4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [[UIImage imageNamed:@"bottom_icon4-hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    foureNav.tabBarItem = item4;
    self.viewControllers = @[fistNav,secondNav,thirdNav,foureNav];
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
