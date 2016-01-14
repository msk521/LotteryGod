//
//  InvitationGoodFriendViewController.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/12.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "InvitationGoodFriendViewController.h"
#import "DZInvitationGoodRequest.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
@interface InvitationGoodFriendViewController ()<UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *quoraImageView;

@end

@implementation InvitationGoodFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UMSocialData setAppKey:UMENKEY];
    [UMSocialWechatHandler setWXAppId:WECHATKEY appSecret:AppSecret url:[NSString stringWithFormat:@"http://www.xycqo2o.com/lgms/user/registThroughInviter.shtml?inviterAccount=%@",[DZAllCommon shareInstance].userInfoMation.account]];
   
    NSString *imagePath = [NSString stringWithFormat:@"%@?account=%@",[DZAllCommon shareInstance].allServiceRespond.qrcode,[DZAllCommon shareInstance].userInfoMation.account];
    [self.quoraImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]]];
}
/**
 *  分享
 *
 *  @param sender
 */
- (IBAction)shareAppFriend:(UIButton *)sender {
    NSDictionary *playDic = [[DZAllCommon shareInstance].currentLottyKind.plays lastObject];
    NSString *shareContent = [NSString stringWithFormat:@"11选5中奖神器，内有分析软件免费用，任5玩法奖金高%@,自动追号，中奖简单方便好玩！",playDic[@"principal"]];
    [self shareResourceWithText:shareContent image:[UIImage imageNamed:@"appiconimg"]];
}

/**
 *  分享
 *
 *  @param text      要分享的文字
 *  @param imageName 分享的图片UMShareToWechatTimeline
 */
-(void)shareResourceWithText:(NSString *)text image:(UIImage *)imageName{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENKEY
                                      shareText:text
                                     shareImage:imageName
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];
}


/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    
}

/**
 点击分享列表页面，之后的回调方法，你可以通过判断不同的分享平台，来设置分享内容。
 例如：
 */
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    
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
