//
//  VKBaseViewController.h
//  OldManChat
//
//  Created by 马士奎 on 15/9/29.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
@interface DZBaseViewController : UIViewController
@property (nonatomic,strong) MBProgressHUD *hud;

-(void)initItemBar;
-(IBAction)goBack:(id)sender;
@end
