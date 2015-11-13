//
//  VKRequest.h
//  OldManChat
//
//  Created by 马士奎 on 15/9/29.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZBaseRequestModel.h"
typedef void (^RequestSuccessFinished)(NSDictionary *);
typedef void (^RequestFaileFinished)(NSString *);
typedef void (^RequestFinished)(NSDictionary *);
@interface DZRequest : NSObject
/**
 *  单例
 *
 *  @return
 */
+(DZRequest *)shareInstance;
/**
 *  请求结束
 *
 *  @param paramter        请求参数
 *  @param RequestFinished 请求成功
 *  @param requestFaile    请求失败
 */
-(void)requestWithParamter:(DZBaseRequestModel*)paramter requestFinish:(RequestSuccessFinished)RequestFinished requestFaile:(RequestFaileFinished)requestFaile;

/**
 *  请求结束
 *
 *  @param paramter        请求参数
 *  @param RequestFinished 请求成功
 *  @param requestFaile    请求失败
 */
-(void)requestWithPDictionaryaramter:(NSDictionary*)paramter requestFinish:(RequestSuccessFinished)RequestFinished requestFaile:(RequestFaileFinished)requestFaile;
@end
