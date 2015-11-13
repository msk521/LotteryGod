//
//  VKBaseModel.m
//  OldManChat
//
//  Created by 马士奎 on 15/9/29.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import "DZBaseRequestModel.h"
@implementation DZBaseRequestModel
-(id)init{
    self = [super init];
    if (self) {
        self.requetType = REQUEST_TYPE_POST;
        self.deviceType = @"1";
        self.requestApi = @"";
        
        
    }
    return self;
}

@end
