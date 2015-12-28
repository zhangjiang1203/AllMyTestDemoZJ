//
//  ZJCustomScaleAnimation.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/9.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJCustomScaleAnimation.h"

@implementation ZJCustomScaleAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    if (self.animationType == KNavAnimationTypePush) {
        
        [containerView addSubview:toVC.view];
        [toVC.view setAlpha:0];
        CGAffineTransform xForm = toVC.view.transform;
        toVC.view.transform = CGAffineTransformScale(xForm, 2.0f, 2.0f);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             [toVC.view setAlpha:1];
                             toVC.view.transform =
                             CGAffineTransformScale(xForm, 1.0f, 1.0f);
                             fromVC.view.transform =
                             CGAffineTransformScale(fromVC.view.transform, 0.9f, 0.9f);
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    else {
        
        [containerView addSubview:toVC.view];
        [containerView addSubview:fromVC.view];
        
        CGAffineTransform xForm = toVC.view.transform;
        toVC.view.transform = CGAffineTransformScale(toVC.view.transform, 0.9f, 0.9f);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             [fromVC.view setAlpha:0];
                             fromVC.view.transform =
                             CGAffineTransformScale(xForm, 2.0f, 2.0f);
                             toVC.view.transform =
                             CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
}
@end
