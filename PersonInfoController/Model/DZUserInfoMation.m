//
//  DZUserInfoMation.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/21.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZUserInfoMation.h"

@implementation DZUserInfoMation

-(id)initWithCoder:(NSCoder *)coder{
    self = [super init];
    if (self) {
        self.account = [coder decodeObjectForKey:@"account"];
        self.idNumber = [coder decodeObjectForKey:@"idNumber"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.sex = [coder decodeObjectForKey:@"sex"];
        self.birthday = [coder decodeObjectForKey:@"birthday"];
        self.phone = [coder decodeObjectForKey:@"phone"];
        self.qq = [coder decodeObjectForKey:@"qq"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.balance = [coder decodeObjectForKey:@"balance"];
        self.score = [coder decodeObjectForKey:@"score"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.account forKey:@"account"];
    [coder encodeObject:self.idNumber forKey:@"idNumber"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.sex forKey:@"sex"];
    [coder encodeObject:self.birthday forKey:@"birthday"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.qq forKey:@"qq"];
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:self.balance forKey:@"balance"];
    [coder encodeObject:self.score forKey:@"score"];
    }
@end
