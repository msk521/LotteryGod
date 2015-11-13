//
//  DZNumberTableViewCell.m
//  LotteryGod
//
//  Created by 马士奎 on 15/10/8.
//  Copyright (c) 2015年 DZ. All rights reserved.
//

#import "DZNumberTableViewCell.h"
#define BALLHIGHLIGHT  123456
@implementation DZNumberTableViewCell

@synthesize selectNumberArray;
@synthesize delegate;
- (void)awakeFromNib {
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        selectNumberArray = [[NSMutableArray alloc] initWithCapacity:0];
        float addEdge = 0.0;
        if (iPhone6) {
            addEdge += 25;
        }else if (iPhone6Plus){
            addEdge += 50;
        }
        //添加十个小球和小球上的数字
        for (NSInteger i = 0; i<3; i++) {
            for (NSInteger j = 0; j<4; j++) {
                if (i == 2 && j >= 3) {
                    continue;
                }
                _redBallImage  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"grey-little-ball%d",(int)(i*4 + j + 1)]]];
                _redBallImage.tag = j+i*4+1+100;
                _redBallImage.frame = CGRectMake(23+addEdge+75*j, 9+(80)*i, 50, 50);
                _redBallImage.userInteractionEnabled = YES;
                [self.contentView addSubview:_redBallImage];
            }
        }
    }
    self.userInteractionEnabled = YES;
    return self;
}

//把选中小球变成红色或取消选择变成白色
- (void)numberImageBackground:(NSInteger)imageTag
{
    
    NSString *selectNumberStr = [NSString stringWithFormat:@"%d",(int)imageTag - 100];
    if ([selectNumberArray count] == 0) {
        [selectNumberArray addObject:selectNumberStr];
        UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:imageTag];
        tmpImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",(int)imageTag - 100]];
        [self.delegate getTotalNotsAndMoney];
        //增加一注
        return;
    }else
    {
        for (NSInteger i = 0;i<[selectNumberArray count];i++) {
            NSString * tmpNumStr = [selectNumberArray objectAtIndex:i];
            if ([tmpNumStr isEqualToString:selectNumberStr]) {
                UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:imageTag];
                tmpImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"grey-little-ball%d",(int)imageTag - 100]];
                [selectNumberArray removeObject:tmpNumStr];
                NSLog(@"数组：%@",selectNumberArray);
                [self.delegate getTotalNotsAndMoney];
                //减少一注
                return;
            }
        }
        
        UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:imageTag];
        tmpImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",(int)imageTag - 100]];
        [selectNumberArray addObject:selectNumberStr];
        NSLog(@"数组：%@",selectNumberArray);
        [self.delegate getTotalNotsAndMoney];
        //增加一注
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //[self.delegate tableViewScrll:YES];
    UITouch *touch = [touches anyObject];
    
    //点击后取得在 cell 上的坐标点
    CGPoint locationCel = [touch locationInView:self.contentView];
    //点击后取得在window上的坐标点
    CGPoint locationWin = [touch locationInView:[UIApplication sharedApplication].delegate.window];
    NSLog(@"x1:%f,y1:%f",locationCel.x,locationCel.y);
    NSLog(@"x2:%f,y2:%f",locationWin.x,locationWin.y);
    
    //删除所有的redballHighlight
    [self removeBallHighlight];
    
    for (NSInteger i = 101 ; i<112; i++) {
        UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:i];
        CGRect tmpRect = tmpImage.frame;
        
        if (CGRectContainsPoint(tmpRect, locationCel)) {
            [self.delegate tableViewScrll:NO];
            
            //删除所有的redballHighlight
            //[self removeBallHighlight];
            
            //所选小号的相对坐标点
            CGPoint locations;
            locations.x = tmpRect.origin.x;
            locations.y = tmpRect.origin.y;
            
            //所选号码
            NSInteger testNumber = i - 100;
            
            //所选小号的绝对坐标点
            CGPoint absoluteCoordinate = [self getSelectNumberPoint:locationWin withCellPoint:locationCel andYofBallorigin:locations];
            
            //把所选号码背景图加到window上
            [self addBallHighlight:testNumber withLocation:absoluteCoordinate];
            return;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    //点击后取得在 cell 上的坐标点
    CGPoint locationCel = [touch locationInView:self.contentView];
    //点击后取得在window上的坐标点
    CGPoint locationWin = [touch locationInView:[UIApplication sharedApplication].delegate.window];
    
    //删除所有的redballHighlight
    [self removeBallHighlight];
    
    for (NSInteger i = 101 ; i<112; i++) {
        UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:i];
        CGRect tmpRect = tmpImage.frame;
        if (CGRectContainsPoint(tmpRect, locationCel)) {
            
            //所选小号的相对坐标点
            CGPoint locations;
            locations.x = tmpRect.origin.x;
            locations.y = tmpRect.origin.y;
            
            //所选号码
            NSInteger testNumber = i - 100;
            
            //所选小号的绝对坐标点
            CGPoint absoluteCoordinate = [self getSelectNumberPoint:locationWin withCellPoint:locationCel andYofBallorigin:locations];
            
            //把所选号码背景图加到window上
            [self addBallHighlight:testNumber withLocation:absoluteCoordinate];
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.contentView];
    
    //删除所有的redballHighlight
    [self removeBallHighlight];
    
    for (NSInteger i = 101 ; i<112; i++) {
        UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:i];
        CGRect tmpRect = tmpImage.frame;
        if (CGRectContainsPoint(tmpRect, location)) {
            
            //删除所有的redballHighlight
            [self removeBallHighlight];
            //选中和再次选中后redball的背景色
            [self numberImageBackground:i];
            return;
        }
    }
    [self.delegate tableViewScrll:YES];
    
}

#pragma mark --
#pragma mark -- 添加点击小图后的大图和大图上数字

- (void)addBallHighlight:(NSInteger)SeleteNumber withLocation:(CGPoint)location
{
    UIImageView *_numberImageGround  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BetRedBallPressed.png"]];
    _numberImageGround.tag = BALLHIGHLIGHT;
    _numberImageGround.frame = CGRectMake(location.x-12.5 , location.y -56, 60, 95);
    _numberImageGround.alpha = 1;
    [[UIApplication sharedApplication].delegate.window addSubview:_numberImageGround];
    
    UILabel *_lableNumberBackground = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _lableNumberBackground.tag = 12345;
    _lableNumberBackground.backgroundColor = [UIColor clearColor];
    _lableNumberBackground.text = [NSString stringWithFormat:@"%d",SeleteNumber];
    _lableNumberBackground.textColor = [UIColor whiteColor];
    _lableNumberBackground.textAlignment = NSTextAlignmentCenter;
    _lableNumberBackground.font = [UIFont boldSystemFontOfSize:25];
    [_numberImageGround addSubview:_lableNumberBackground];
}

#pragma mark --
#pragma mark -- 清空所有数据和选择随机数

- (void)refreshDataWith:(NSMutableArray *)slecteStr
{
    NSLog(@"slecteStr:%@",slecteStr);
    //清空所有选择数据
    [selectNumberArray removeAllObjects];
    for (int i = 101; i<112; i++) {
        UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:i];
        tmpImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"grey-little-ball%d",i - 100]];
    }
    
    if (slecteStr.count == 0) {
        [self.delegate getTotalNotsAndMoney];
        return;
    }else
    {
        //摇动后随即选出的一个数字
        for (int i = 101; i<112; i++) {
            NSString * tmpNumStr = [NSString stringWithFormat:@"%d",i-100];
            if ([slecteStr containsObject:tmpNumStr]) {
                UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:i];
                tmpImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ball%d",i - 100]];
                [selectNumberArray addObject:tmpNumStr];
                NSLog(@"数组：%@",selectNumberArray);
            }else
            {
                UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:i];
                tmpImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"grey-little-ball%d",i - 100]];
            }
        }
    }
    [self.delegate getTotalNotsAndMoney];
}

#pragma mark --
#pragma mark -- 删除点击小图后的大图和大图上数字
- (void)removeBallHighlight
{
    for (UIView *tmpView in [UIApplication sharedApplication].delegate.window.subviews) {
        if (tmpView.tag == BALLHIGHLIGHT) {
            [tmpView removeFromSuperview];
        }
    }
}

#pragma mark --
#pragma mark -- 获取cell上点击ball按钮的绝对坐标

- (CGPoint)getSelectNumberPoint:(CGPoint)windowPoint withCellPoint:(CGPoint)cellPoint andYofBallorigin:(CGPoint)cellBallOrigin
{
    CGPoint testPoint ;
    if (windowPoint.x >= 239) {
        testPoint.x = 239;
    }else if (windowPoint.x >= 193)
    {
        testPoint.x = 193;
    }else if (windowPoint.x >= 147)
    {
        testPoint.x = 147;
    }else if (windowPoint.x >= 101)
    {
        testPoint.x = 101;
    }else if (windowPoint.x >= 55)
    {
        testPoint.x = 55;
    }
    testPoint.y = windowPoint.y - cellPoint.y + cellBallOrigin.y;
    
    return testPoint;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
