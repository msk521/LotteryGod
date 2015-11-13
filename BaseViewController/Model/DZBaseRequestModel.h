//
//  VKBaseModel.h
//  OldManChat
//
//  Created by 马士奎 on 15/9/29.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface DZBaseRequestModel : MTLModel
-(id)init;
/**
 *  请求方式（get post）
 */
@property (nonatomic,copy) NSString *requetType;
/**
 *  请求接口
 */
@property (nonatomic,copy) NSString *requestApi;
/**
 *  请求设备类型（0 android 1 iOS）
 */
@property (nonatomic,copy) NSString *deviceType;
/**
 *  用户手机
 */
@property (nonatomic,copy) NSString *mobile;
@end
