//
//  ZJCardView.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/25.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJCardView.h"

@interface ZJCardView ()

@end

@implementation ZJCardView

-(void)awakeFromNib{
    self.showFlagTitleLabel.hidden = YES;
    self.showFlagImage.hidden = YES;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = KRGBA(100, 100, 100, 1).CGColor;
    self.layer.borderWidth = 1;
    
}


-(void)setCardsArr:(NSMutableArray *)cardsArr{

    _cardsArr = cardsArr;
}


@end
