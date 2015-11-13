//
//  DZAllService.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/20.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseModel.h"
@interface DZAllServiceRespond : DZBaseModel
//获取彩种
@property (nonatomic,copy) NSString *lotterys;
////高级追号计划生成
//@property (nonatomic,copy) NSString *chasePlanGenerators;
//生产追号计划
@property (nonatomic,copy) NSString *chasePlanGenerate;
//注册
@property (nonatomic,copy) NSString *userRegist;
//登录
@property (nonatomic,copy) NSString *userLogin;
//修改用户信息
@property (nonatomic,copy) NSString *userUpdate;
//收支明细
@property (nonatomic,copy) NSString *userBalanceChange;
//投注
@property (nonatomic,copy) NSString *lotteryOrderCreate;
//彩种信息
@property (nonatomic,copy) NSString *lotteryInfo;
//用户订单
@property (nonatomic,copy) NSString *lotteryOrderList;
//撤单
@property (nonatomic,copy) NSString *lotteryOrderCancel;
//获取验证码
@property (nonatomic,copy) NSString *sendVerificationCode;
//获取金币银币说
@property (nonatomic,copy) NSString *userInfo;
//提现
@property (nonatomic,copy) NSString *userApplyWithdrawals;
//提现记录
@property (nonatomic,copy) NSString *userWithdrawalsApply;
//获取二维码
@property (nonatomic,copy) NSString *qrcode;
@end




