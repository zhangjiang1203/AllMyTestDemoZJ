//
//  ZJCardView.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/25.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJCardView.h"

@interface ZJCardView ()
{
    CGFloat viewW ;
    CGFloat viewH ;
}

@end

@implementation ZJCardView

-(instancetype)initWithFrame:(CGRect)frame finish:(AnimationFinishBlock)finishBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.finishBlock = finishBlock;
        viewH = frame.size.height;
        viewW = frame.size.width;
        [self setCardsArr:@[@"1",@"2",@"3",@"4"]];
    }
    return self;
}

-(void)awakeFromNib{
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
}


-(void)setCardsArr:(NSMutableArray *)cardsArr{
//    _cardsArr = cardsArr;
    for ( int i = 0; i<cardsArr.count; i++) {
        UILabel *animView = [[UILabel alloc]init];
        animView.text = @"jiushizheyang de ";
        animView.frame = CGRectMake(0, 0, viewW, viewH-40);
//        animView.center = CGPointMake(viewW/2, ViewH/2+10*i);
        animView.backgroundColor = [self getRandomColor];
        [self addSubview:animView];
    }
}



//获取随机颜色
-(UIColor*)getRandomColor{
    CGFloat red = arc4random()%255;
    CGFloat blue = arc4random()%255;
    CGFloat green = arc4random()%255;
    
    return KRGBA(red, blue, green, 1);
    
}
@end
