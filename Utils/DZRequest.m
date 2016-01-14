//
//  VKRequest.m
//  OldManChat
//
//  Created by 马士奎 on 15/9/29.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import "DZRequest.h"
#import <MKNetworkKit/MKNetworkKit.h>
@implementation DZRequest
/**
 *  单例
 *
 *  @return
 */
+(DZRequest *)shareInstance{
    static dispatch_once_t onceToken;
    static DZRequest *vkRequest = nil;
    dispatch_once(&onceToken, ^{
        vkRequest  = [[DZRequest alloc] init];
    });
    return vkRequest;
}

//请求
-(void)requestWithParamter:(DZBaseRequestModel*)paramter requestFinish:(RequestSuccessFinished)RequestFinished requestFaile:(RequestFaileFinished)requestFaile{
    
    NSDictionary *param = [paramter dictionaryValue];
    NSMutableDictionary *mParam = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [mParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isEqual:[NSNull null]]) {
            [mParam setObject:@"" forKey:key];
        }
    }];
    //服务器地址
    NSString *hostURL = BASEURL;
    //实例化数据请求forHTTPHeaderField
    NSString *apiPath = mParam[REQUEST_WEB_API];
    
    //拼接 请求地址
    NSString *urlString = [NSString stringWithFormat:@"%@%@",hostURL,apiPath];
    //请求方式
    NSString *requestType = paramter.requetType;
    
    NSLog(@"mParam:%@",[mParam jsonEncodedKeyValueString]);
    
    MKNetworkEngine *mkEngine = [[MKNetworkEngine alloc] init];
    
    MKNetworkOperation *op = [mkEngine operationWithURLString:urlString params:mParam httpMethod:requestType];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"respond:%@",completedOperation.responseJSON);
        NSDictionary *dic = completedOperation.responseJSON;
        if (dic[@"success"] && [dic[@"success"] intValue] == 0) {
            [DZUtile showAlertViewWithMessage:dic[@"errorMessage"]];
            if (requestFaile) {
                requestFaile(dic[@"errorMessage"]);
            }
            return ;
        }
        
        if (RequestFinished) {
            RequestFinished(completedOperation.responseJSON);
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"MKNetwork request error : %@", [error localizedDescription]);
        if (requestFaile) {
            requestFaile([error localizedDescription]);
        }
        
    }];
    [mkEngine enqueueOperation:op];
}


//使用字典为参数请求
-(void)requestWithPDictionaryaramter:(NSDictionary*)paramter requestFinish:(RequestSuccessFinished)RequestFinished requestFaile:(RequestFaileFinished)requestFaile{
    
    NSDictionary *param = paramter;
    NSMutableDictionary *mParam = [NSMutableDictionary dictionaryWithDictionary:param];
    
    [mParam enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isEqual:[NSNull null]]) {
            [mParam setObject:@"" forKey:key];
        }
    }];
    //服务器地址
    NSString *hostURL = BASEURL;
    //实例化数据请求forHTTPHeaderField
    NSString *apiPath = mParam[REQUEST_WEB_API];
    
    //拼接 请求地址
    NSString *urlString = [NSString stringWithFormat:@"%@%@",hostURL,apiPath];
    //请求方式
    NSString *requestType = REQUEST_TYPE_POST;
    
    NSLog(@"mParam:%@",[mParam jsonEncodedKeyValueString]);
    
    MKNetworkEngine *mkEngine = [[MKNetworkEngine alloc] init];
    
    MKNetworkOperation *op = [mkEngine operationWithURLString:urlString params:mParam httpMethod:requestType];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"respond:%@",completedOperation.responseJSON);
        NSDictionary *dic = completedOperation.responseJSON;
        if (dic[@"success"] && dic[@"success"] == NO) {
            [DZUtile showAlertViewWithMessage:dic[@"errorMessage"]];
            if (requestFaile) {
                requestFaile(dic[@"errorMessage"]);
            }
            return ;
        }
        
        if (RequestFinished) {
            RequestFinished(completedOperation.responseJSON);
        }
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"MKNetwork request error : %@", [error localizedDescription]);
        if (requestFaile) {
            requestFaile([error localizedDescription]);
        }
        
    }];
    [mkEngine enqueueOperation:op];
}


@end
