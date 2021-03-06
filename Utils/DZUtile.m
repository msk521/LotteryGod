//
//  VKUtile.m
//  OldManChat
//
//  Created by 马士奎 on 15/9/29.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import "DZUtile.h"
#import "AppDelegate.h"

static UIViewController *currentController;

LoadingLogingControllerFinished leftControllerHidden;
DZLoginViewController *currentLoginController;

@implementation DZUtile
//显示/隐藏登录
+(void)showLoginViewController:(DZLoginViewController *)loginController animation:(BOOL)animation finishLoading:(LoadingLogingControllerFinished)finishLoading hiddenFinish:(LoadingLogingControllerFinished)hiddenFinish{
    AppDelegate *main = [UIApplication sharedApplication].delegate;
    if (loginController) {
        currentLoginController = loginController;
    }
    currentLoginController.loginSuccess = ^(){
      //登录成功
        __block CGRect mainFrame = main.window.frame;
        [UIView animateWithDuration:0.3f animations:^{
            mainFrame.origin.x = loginController.view.frame.size.width;
            currentLoginController.view.frame = mainFrame;
        } completion:^(BOOL finished) {
            
        }];
    };
    
    currentLoginController.loginCancel = ^(){
        //取消登录
        __block CGRect mainFrame = main.window.frame;
        [UIView animateWithDuration:0.3f animations:^{
            mainFrame.origin.x = loginController.view.frame.size.width;
            currentLoginController.view.frame = mainFrame;
        } completion:^(BOOL finished) {
            if (hiddenFinish) {
                hiddenFinish();
            }
        }];
    };

    if (animation) {
        //动画方式显示
        __block CGRect mainFrame = main.window.frame;
        mainFrame.origin.x += loginController.view.frame.size.width;
        loginController.view.frame = mainFrame;
        [main.window addSubview:loginController.view];
        [UIView animateWithDuration:0.3f animations:^{
            mainFrame.origin.x = 0;
            loginController.view.frame = mainFrame;
        } completion:^(BOOL finished) {
            
        }];
        
    }else{
        //无动画方式显示
        loginController.view.frame = main.window.frame;
        [main.window addSubview:loginController.view];
    }
}

//侧滑显示view
+(void)showLetfViewController:(UIViewController *)letController finishLoading:(LoadingLogingControllerFinished)finishLoading hiddenFinish:(LoadingLogingControllerFinished)hiddenFinish{
    currentController = letController;
    AppDelegate *main = [UIApplication sharedApplication].delegate;
    if (hiddenFinish) {
        leftControllerHidden = hiddenFinish;
    }
    if (letController) {
        __block CGRect mainFrame = main.window.frame;
        mainFrame.origin.x -= letController.view.frame.size.width;
        letController.view.backgroundColor = [UIColor clearColor];
        letController.view.frame = mainFrame;
        [main.window addSubview:letController.view];
        [UIView animateWithDuration:0.4f animations:^{
            mainFrame.origin.x = 0;
            letController.view.frame = mainFrame;
        } completion:^(BOOL finished) {
            
            UIView *bgView = [[UIView alloc] initWithFrame:letController.view.frame];
            [letController.view addSubview:bgView];
            [letController.view sendSubviewToBack:bgView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenLeftViewController:)];
            
            [bgView addGestureRecognizer:tap];
            
            if (finishLoading) {
                //显示结束
                finishLoading();
            }
        }];
    }
}

//隐藏左侧view
+(void)hiddenLeftViewController:(UITapGestureRecognizer *)tap{
    if (currentController) {
        __block CGRect frame = currentController.view.frame;
        [UIView animateWithDuration:0.3f animations:^{
            frame.origin.x = -frame.size.width;
            currentController.view.frame = frame;
        } completion:^(BOOL finished) {
            if (leftControllerHidden) {
                leftControllerHidden();
            }
        }];
    }
}

//存储数据到本地
+(void)saveSomeDataToUserDefaulter:(NSString *)objc forkey:(NSString *)key{
    NSUserDefaults *defaulter = [NSUserDefaults standardUserDefaults];
    [defaulter setObject:objc forKey:key];
    [defaulter synchronize];
}

//查询本地存储的数据
+(NSString *)searchObjcFromUserDefaulter:(NSString *)key{
    NSUserDefaults *defaulter = [NSUserDefaults standardUserDefaults];
    return [defaulter objectForKey:key];
}

//存储数据到本地plist中
+(void)saveDataToFile:(NSDictionary *)dic withFileName:(NSString *)fileName{
    NSString *fileFullName = [NSString stringWithFormat:@"%@.plist",fileName];
    NSString *filePath = DOCUMENT(fileFullName);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSMutableDictionary *mParam = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [mParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isEqual:[NSNull null]]) {
            [mParam setObject:@"" forKey:key];
        }
    }];
    
    [mParam writeToFile:filePath atomically:YES];
}

//从本地文件名中获取数据
+(NSDictionary *)receiveDataFromPlist:(NSString *)fileName{
    NSString *fileFullName = [NSString stringWithFormat:@"%@.plist",fileName];
    NSString *filePath = DOCUMENT(fileFullName);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSDictionary *result = [NSDictionary dictionaryWithContentsOfFile:filePath];
        return result;
    }
    return nil;
}

//弹出提示框
+(void)showAlertViewWithMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}

//计算时间差多少秒
+(NSInteger)requestTimeMinusWith:(NSString *)lastTime{
    //将传入时间转化成需要的格式
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"yyyy:%@",[[lastTime componentsSeparatedByString:@"."] firstObject]);
    NSDate *fromdate=[format dateFromString:[[lastTime componentsSeparatedByString:@"."] firstObject]];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    NSLog(@"fromdate=%@",fromDate);
    //获取当前时间
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"localeDate=%@",localeDate);
   NSInteger iSeconds = [localeDate timeIntervalSinceDate:fromDate];
    return iSeconds;
}
/**
 *  存储用户数据
 */
+(void)saveData{
    NSUserDefaults *defaulters = [NSUserDefaults standardUserDefaults];
    DZUserInfoMation *userInfoMation = [DZAllCommon shareInstance].userInfoMation;
    if (userInfoMation) {
        NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:userInfoMation];
        [defaulters setObject:data forKey:@"UserInfo"];
    }
    [defaulters synchronize];
}
/**
 *  检测时间
 *
 *  @return
 */
+(BOOL)checkTime{
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"HH:mm:ss"];
    NSDate *fistDate = [dateForm dateFromString:[DZAllCommon shareInstance].currentLottyKind.firstTime];
    NSDate *lastDate = [dateForm dateFromString:[DZAllCommon shareInstance].currentLottyKind.lastTime];
    if (!fistDate || !lastDate) {
        return NO;
    }
    NSString *fistTime = [[dateForm stringFromDate:fistDate] stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *lastTime = [[dateForm stringFromDate:lastDate] stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *currentTime = [[dateForm stringFromDate:[NSDate date]] stringByReplacingOccurrencesOfString:@":" withString:@""];
    AppDelegate *delegae = [UIApplication sharedApplication].delegate;
    if (currentTime.intValue > fistTime.intValue && currentTime.intValue < lastTime.intValue) {
        return NO;
    }else{
        delegae.shouldAgainRequestWinNumber = YES;
        [DZUtile showAlertViewWithMessage:[NSString stringWithFormat:@"开奖时间为%@--%@",[DZAllCommon shareInstance].currentLottyKind.firstTime,[DZAllCommon shareInstance].currentLottyKind.lastTime]];
        return YES;
    }
}

@end
