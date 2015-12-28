//
//  UITableView+LoadAnimation.h
//  tableView动画实现
//
//  Created by zhangjiang on 15/6/23.
//  Copyright (c) 2015年 张江. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    AnimationDirectTop,
    AnimationDirectBottom,
    AnimationDirectLeft,
    AnimationDirectRight
}AnimationDirect;
@interface UITableView (LoadAnimation)
@property (assign,nonatomic)AnimationDirect *animDirect;
/**
 *  UITableView重新加载动画
 *
 *  @param   direct    cell运动方向
 *  @param   time      动画持续时间
 *  @param   interval  每个cell间隔
 */
-(void)reloadDataWithAnimate:(AnimationDirect)direct animationTime:(NSTimeInterval)animTime interVal:(NSTimeInterval)interTime;


@end
