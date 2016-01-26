//
//  ZJCircleView.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/26.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ZJCircleView : UIView
/**
 *  圆环的颜色
 */
@property (nonatomic,strong)IBInspectable UIColor *circleColor;

/**
 *  圆环的宽度
 */
@property (nonatomic)IBInspectable CGFloat circleWidth;

/**
 *  圆环的完成百分比,值在0.0-1.0之间
 */
@property (nonatomic)IBInspectable CGFloat circlePercentage;

/**
 *  显示的文本颜色，不设置的话默认是白色
 */
@property (nonatomic,strong)IBInspectable UIColor *titleColor;

@end
