//
//  VKCoolOrHotNumberTableViewCell.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/13.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "VKCoolOrHotNumberTableViewCell.h"
@interface VKCoolOrHotNumberTableViewCell(){
    //近多少期冷热号
    __weak IBOutlet UILabel *muchNumber;
    //平均出现
    __weak IBOutlet UILabel *advAppears;
}
@end

@implementation VKCoolOrHotNumberTableViewCell

- (void)awakeFromNib {
    
}

-(void)initImageView{
    
    int with = (self.frame.size.width / 11);
    int minus = 0;
    int plus = 26;
    if (iPhone6) {
        minus = 0;
        plus = 30;
    }else if (iPhone6Plus){
        minus = 0;
        plus = 28;
    }
    with = with - minus;
    for (int i = 0; i < 12; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * with-plus, 200 - with - 5, with-5, with-5)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",i]];
        imageView.tag = 100 + i;
        [self.contentView addSubview:imageView];
        
        UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width / 4, 0, imageView.frame.size.width / 2, 0)];
        colorLabel.tag = 200 + i ;
        CGPoint point = imageView.center;
        point.y -= imageView.frame.size.width / 2 + 3;
        point.x += imageView.frame.size.width+ 5;
        colorLabel.center = point;
        [self.contentView addSubview:colorLabel];
    }

}
//每个号码共出现多少次
-(void)replay:(NSDictionary *)percents totalNum:(int)totlaNum{
    muchNumber.text = [NSString stringWithFormat:@"近%d期数据",totlaNum];
    for (UIView *view in self.contentView.subviews) {
        if(view.tag == 0){
            continue;
        }
        [view removeFromSuperview];
    }
    [self initImageView];
    UIColor *redColor = COLOR(245, 74, 53);
    UIColor *bluColor = COLOR(234, 180, 60);
    UIColor *yellowColor = COLOR(65,149,222);
     UILabel *labtemp = (UILabel *)[self viewWithTag:200];
    int hight = labtemp.frame.origin.y - muchNumber.frame.origin.y - muchNumber.frame.size.height * 2;
    for (int i = 0; i < percents.count; i++) {
        UILabel *lab = (UILabel *)[self viewWithTag:200 + i];
        NSString *nums = [NSString stringWithFormat:@"%d",(int)[percents[@(i+1)] count]];
        float per = nums.floatValue / totlaNum;
        CGRect rect = lab.frame;
        rect.origin.y -= per * hight;
        rect.size.height += per * hight;
        lab.frame = rect;
        if (lab) {
            if (lab) {
                if (totlaNum - nums.intValue < 10) {
                    lab.backgroundColor = redColor;
                }else if ( 10 <totlaNum - nums.intValue && totlaNum - nums.intValue < 15){
                    lab.backgroundColor = yellowColor;
                }else{
                     lab.backgroundColor = bluColor;
                }
            }
        }
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(lab.frame.origin.x, lab.frame.origin.y - 10, lab.frame.size.width, 10)];
        num.font = [UIFont systemFontOfSize:10];
        num.textAlignment = NSTextAlignmentCenter;
        num.text = nums;
        num.tag = 300+i;
        [self.contentView addSubview:num];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
