//
//  ZJDashboardView.h
//  DashboardDemo
//
//  Created by pg on 2017/1/5.
//  Copyright © 2017年 bestdew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJDashboardView : UIView

/**
 外围 内围 大刻度和文字的颜色
 */
@property (nonatomic,strong)UIColor *circleColor;

/**
 小刻度的颜色
 */
@property (nonatomic,strong)UIColor *smallDegreeColor;

/**
 渐变颜色数组
 */
@property (nonatomic,strong)NSArray<UIColor*> *gradientColors;

/**
 当前的刻度值 0-1
 */
@property (nonatomic,assign)CGFloat strokeEnd;

@end
