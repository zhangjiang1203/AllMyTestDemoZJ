//
//  WCChildRouteCell.m
//  Xiaoxin
//
//  Created by zhangjiang on 15/9/2.
//  Copyright (c) 2015年 juzi. All rights reserved.
//

#import "WCChildRouteCell.h"

@implementation WCChildRouteCell

+(instancetype)cellForTableView:(UITableView *)tableView{
    static NSString *identifier = @"WCChildRouteCell";
    WCChildRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WCChildRouteCell" owner:nil options:nil]lastObject];
    }
    return cell;
}

//-(void)setLocationModel:(WCChildLocationModel *)locationModel{
//    _locationModel = locationModel;
//    self.addressLabel.text = _locationModel.addr;
//    self.timeLabel.text = [_locationModel.uploadTime substringWithRange:NSMakeRange(11, 8)];
//    self.userTimeLabel.text = [NSString stringWithFormat:@"%zd'",_locationModel.disMinutes];
//}

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
}

@end
