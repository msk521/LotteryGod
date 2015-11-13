//
//  DZLottySearchRequet.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/18.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZBaseRequestModel.h"

@interface DZLottySearchRequet : DZBaseRequestModel
-(id)init;
//每页显示多少
@property (nonatomic,assign) int pageCount;
//第几页
@property (nonatomic,assign) int pageIndex;
@end
