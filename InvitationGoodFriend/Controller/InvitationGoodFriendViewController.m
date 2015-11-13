//
//  InvitationGoodFriendViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/12.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "InvitationGoodFriendViewController.h"
#import "DZInvitationGoodRequest.h"
@interface InvitationGoodFriendViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *quoraImageView;

@end

@implementation InvitationGoodFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *imagePath = [NSString stringWithFormat:@"%@?account=%@",[DZAllCommon shareInstance].allServiceRespond.qrcode,[DZAllCommon shareInstance].userInfoMation.account];
    [self.quoraImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]]];
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
