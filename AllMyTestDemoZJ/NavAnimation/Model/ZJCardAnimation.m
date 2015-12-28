//
//  ZJCardAnimation.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/8.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJCardAnimation.h"

@implementation ZJCardAnimation
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *contentView = [transitionContext containerView];
    CGRect initFrame = [transitionContext initialFrameForViewController:fromViewController];
    if (self.animationType == KNavAnimationTypePush) {
        
        CGRect offScreenFrame = initFrame;
        offScreenFrame.origin.y = offScreenFrame.size.height;
        toViewController.view.frame = offScreenFrame;
        [contentView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        
        CATransform3D t1 = [self firstTransform];
        CATransform3D t2 = [self secondTransformWithView:fromViewController.view];
        //添加关键帧动画
        [UIView animateKeyframesWithDuration:self.duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
            //FromView动画
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.4 animations:^{
                fromViewController.view.layer.transform = t1;
                fromViewController.view.alpha = 0.6;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.4 animations:^{
                fromViewController.view.layer.transform = t2;
            }];
            
            //TOView动画
            [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.2 animations:^{
                toViewController.view.frame = CGRectOffset(toViewController.view.frame, 0.0, -30.0);
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.8f relativeDuration:0.2f animations:^{
                toViewController.view.frame = initFrame;
            }];
            
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }else{
        toViewController.view.frame = initFrame;
        CATransform3D scale = CATransform3DIdentity;
        toViewController.view.layer.transform = CATransform3DScale(scale, 0.6, 0.6, 1);
        toViewController.view.alpha = 0.6;
        
        [contentView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        
        CGRect frameOffScreen = initFrame;
        frameOffScreen.origin.y = initFrame.size.height;
        
        CATransform3D t1 = [self firstTransform];
        
        [UIView animateKeyframesWithDuration:self.duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
            
            // push the from- view off the bottom of the screen
            [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.5f animations:^{
                fromViewController.view.frame = frameOffScreen;
            }];
            
            // animate the to- view into place
            [UIView addKeyframeWithRelativeStartTime:0.35f relativeDuration:0.35f animations:^{
                toViewController.view.layer.transform = t1;
                toViewController.view.alpha = 1.0;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.75f relativeDuration:0.25f animations:^{
                toViewController.view.layer.transform = CATransform3DIdentity;
            }];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                toViewController.view.layer.transform = CATransform3DIdentity;
                toViewController.view.alpha = 1.0;
            }
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}


-(CATransform3D)firstTransform{
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f * M_PI/180.0f, 1, 0, 0);
    return t1;
    
}

-(CATransform3D)secondTransformWithView:(UIView*)view{
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = [self firstTransform].m34;
    t2 = CATransform3DTranslate(t2, 0, view.frame.size.height*-0.08, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    return t2;
}

@end
