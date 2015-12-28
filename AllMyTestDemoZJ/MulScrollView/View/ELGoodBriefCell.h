//
//  ELGoodBriefCell.h
//  eLife
//
//  Created by zhangjiang on 15/7/1.
//  Copyright (c) 2015年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELGoodBriefCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImage;
@property (weak, nonatomic) IBOutlet UIImageView *prasieImage;
@property (weak, nonatomic) IBOutlet UILabel *praiseCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;


@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;


@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIView *topBackView;
+(ELGoodBriefCell*)cellWithTableView:(UITableView*)tableview;
@end
