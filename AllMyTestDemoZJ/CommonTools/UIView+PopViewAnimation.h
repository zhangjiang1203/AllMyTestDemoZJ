//
//  UIView+PopViewAnimation.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/2.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PopViewAnimation)<POPAnimationDelegate>
/**
 *  视图弹出动画,针对的只是view的frame中的y值变化
 *  可以自定义视图从上还是从下弹出
 *  @param view 添加的视图
 *  @param from 开始的y值
 *  @param to   结束的y值
 */
-(void)popAnimationFlyInWithView:(UIView*)popView from:(CGFloat)from to:(CGFloat)to finish:(AnimationSuccessBlock)animationBlock;


/**
 *  视图弹出动画,针对的只是view的frame中的y值变化
 *  可以自定义视图从上还是从下消失
 *  @param view 添加的视图
 *  @param from 开始的y值
 *  @param to   结束的y值
 */
-(void)popAnimationFlyOutWithView:(UIView*)popView from:(CGFloat)from to:(CGFloat)to finish:(AnimationSuccessBlock)animationBlock;
@end
