//
//  ZJNavScaleAnimation.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/7.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJNavScaleAnimation.h"

@implementation ZJNavScaleAnimation

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *contentView = [transitionContext containerView];
    //初始化各种view的参数
    toViewController.view.transform = CGAffineTransformMakeScale(0, 0);
    fromViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    toViewController.view.alpha = 0.0;
    [contentView insertSubview:toViewController.view aboveSubview:fromViewController.view];
    
    //改变位置变换
    [UIView animateWithDuration:self.duration animations:^{
        toViewController.view.alpha = 1.0;
        toViewController.view.transform = CGAffineTransformMakeScale(1.0,1.0);
        
        fromViewController.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
        fromViewController.view.alpha = 0.0;
        
    }completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}


@end
