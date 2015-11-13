//
//  VKBaseModel.m
//  OldManChat
//
//  Created by 马士奎 on 15/9/29.
//  Copyright (c) 2015年 WK. All rights reserved.
//

#import "DZBaseModel.h"

@implementation DZBaseModel
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (dic) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
