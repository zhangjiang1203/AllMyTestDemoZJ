//
//  ZJNavBaseAnimation.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/7.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 定义一个动画的枚举类型
 */
typedef enum {
    KNavAnimationTypePush,
    KNavAnimationTypePop
}KNavAnimationType;

@interface ZJNavBaseAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) KNavAnimationType animationType;

@property (assign, nonatomic)NSTimeInterval duration;
@end
