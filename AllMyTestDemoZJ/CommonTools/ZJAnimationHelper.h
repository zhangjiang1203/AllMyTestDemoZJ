//
//  ZJAnimationHelper.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/26.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AnimationSuccessBlock)(BOOL isFinish);

@interface ZJAnimationHelper : NSObject
/**
 *  视图旋转动画
 */
+(void)setRotationWithAngle:(CGFloat)angle duration:(CGFloat)duration view:(UIView*)animationView;

/**
 *  视图透明度动画
 */
+(void)setViewAlpha:(CGFloat)alpha duration:(CGFloat)duration view:(UIView*)animationView;

/**
 *  视图中心点动画
 */
+(void)setCenter:(CGPoint)center duration:(CGFloat)duration view:(UIView*)animationView;

/**
 *  视图放缩动画
 */
+(void)setScale:(CGFloat)present duration:(CGFloat)duration view:(UIView*)animationView;

/**
 *  视图弹出动画,针对的只是view的frame中的y值变化
 *  可以自定义视图从上还是从下弹出
 *  @param view 添加的视图
 *  @param from 开始的y值
 *  @param to   结束的y值
 */
+(void)popAnimationFlyInWithView:(UIView*)popView from:(CGFloat)from to:(CGFloat)to finish:(AnimationSuccessBlock)animationBlock;

/**
 *  视图弹出动画,针对的只是view的frame中的y值变化
 *  可以自定义视图从上还是从下消失
 *  @param view 添加的视图
 *  @param from 开始的y值
 *  @param to   结束的y值
 */
+(void)popAnimationFlyOutWithView:(UIView*)popView from:(CGFloat)from to:(CGFloat)to finish:(AnimationSuccessBlock)animationBlock;

/**
 *  改变label上的数字的变化
 *
 *  @param label  添加的label
 *  @param suffix 文字前缀或者后缀
 *  @param from   开始的值
 *  @param to     结束值
 *  @param time   持续时间
 */
+(void)makeNumChangeWithView:(UILabel*)label string:(NSString*)suffix FromValue:(CGFloat)from toValue:(CGFloat)to time:(CGFloat)time;
@end
