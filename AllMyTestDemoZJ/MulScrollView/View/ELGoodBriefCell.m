//
//  ELGoodBriefCell.m
//  eLife
//
//  Created by zhangjiang on 15/7/1.
//  Copyright (c) 2015年 zhangjiang. All rights reserved.
//

#import "ELGoodBriefCell.h"

@implementation ELGoodBriefCell
+(instancetype)cellWithTableView:(UITableView *)tableview{
    static NSString *identifier = @"ELGoodBriefCell";
    ELGoodBriefCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ELGoodBriefCell" owner:nil options:nil]lastObject];
    }
    return cell;
}
- (void)awakeFromNib {
    
    
    self.titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];    //设置文本的阴影色彩和透明度。
    self.titleLabel.shadowOffset = CGSizeMake(0.5f, 0.5f);     //设置阴影的倾斜角度。
    self.timeLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];    //设置文本的阴影色彩和透明度。
    self.timeLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);     //设置阴影的倾斜角度。
    [self.goodImageView.layer addSublayer:[HUDHelper drawLineGradient:KRGBA(0, 0, 0, 0.4) buttomColor:KRGBA(255, 255, 255, 0.05) startpoint:CGPointMake(0.5, 0)endpoint:CGPointMake(0.5, 1) frame:CGRectMake(0, 0, ScreenWidth, 80)]];
    self.userHeaderImage.layer.cornerRadius = self.userHeaderImage.frame.size.width/2;
    self.userHeaderImage.layer.masksToBounds = YES;
    self.userHeaderImage.layer.borderWidth = 1;
    self.userHeaderImage.layer.borderColor = KRGBA(245, 115, 76, 1).CGColor;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(choosePraiseImage:) name:KPraiseImage object:nil];
    
    
}

-(void)choosePraiseImage:(NSNotification*)noti{
    self.prasieImage.image = [UIImage imageNamed:@"button_praise_se"];
    [HUDHelper makeScale:self.prasieImage delegate:self scale:1.2 duration:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
