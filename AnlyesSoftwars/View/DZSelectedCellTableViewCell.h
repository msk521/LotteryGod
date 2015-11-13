//
//  DZSelectedCellTableViewCell.h
//  LotteryGod
//
//  Created by 马士奎 on 15/10/22.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZAnlyesSelectedRespond.h"
typedef void (^DeleteData)();
@interface DZSelectedCellTableViewCell : UITableViewCell
@property (nonatomic,copy) DeleteData deleteData;
-(void)repaly:(DZAnlyesSelectedRespond *)respond;
@end
