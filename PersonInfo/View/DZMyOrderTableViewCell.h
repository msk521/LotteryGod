//
//  DZMyOrderTableViewCell.h
//  LotteryGod
//
//  Created by 马士奎 on 15/11/1.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZMyOrderListRespond.h"
typedef void (^CancelOrder)(NSString*);
typedef void (^LookDetail)(DZMyOrderListRespond *);
@interface DZMyOrderTableViewCell : UITableViewCell
@property (nonatomic,copy) CancelOrder cancelOrder;
@property (nonatomic,copy) LookDetail lookDetail;
-(void)replay:(DZMyOrderListRespond *)respond;
@end
