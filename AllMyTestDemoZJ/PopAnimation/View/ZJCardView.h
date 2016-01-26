//
//  ZJCardView.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/25.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZJCardView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *showFlagImage;
@property (weak, nonatomic) IBOutlet UILabel *showFlagTitleLabel;
/**
 *  显示的card总数
 */
@property (nonatomic,strong)NSMutableArray *cardsArr;





@end
