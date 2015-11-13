//
//  BIDDatePickerView.m
//  HappyWeddingShop
//
//  Created by 马士奎 on 15/7/6.
//  Copyright (c) 2015年 zhanghongwei. All rights reserved.
//

#import "BIDDatePickerView.h"

@implementation BIDDatePickerView
/**
 *  取消
 *
 *  @param sender
 */
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    self.selectedItem(0);
}

/**
 *  确定
 *
 *  @param sender
 */
- (IBAction)showSelected:(UIBarButtonItem *)sender {
    self.selectedItem(1);
}

@end
