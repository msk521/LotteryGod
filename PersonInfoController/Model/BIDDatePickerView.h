//
//  BIDDatePickerView.h
//  HappyWeddingShop
//
//  Created by 马士奎 on 15/7/6.
//  Copyright (c) 2015年 zhanghongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectedItem)(int);
@interface BIDDatePickerView : UIView
@property (nonatomic,copy) SelectedItem selectedItem;
/**
 *  日期选择器
 */
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
/**
 *  取消
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelItem;
/**
 *  确定
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showItem;

@end
