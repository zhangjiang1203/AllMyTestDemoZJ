//
//  WCChildRouteCell.h
//  Xiaoxin
//
//  Created by zhangjiang on 15/9/2.
//  Copyright (c) 2015年 juzi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WCChildLocationModel.h"
@interface WCChildRouteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UILabel *userTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *topLineLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLineLabel;




//@property (nonatomic,strong)WCChildLocationModel *locationModel;

+(instancetype)cellForTableView:(UITableView *)tableView;

@end
