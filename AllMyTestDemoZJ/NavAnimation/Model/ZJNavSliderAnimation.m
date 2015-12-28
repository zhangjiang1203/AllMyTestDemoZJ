//
//  ZJNavSliderAnimation.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/9.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJNavSliderAnimation.h"

@implementation ZJNavSliderAnimation
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *contentView = [transitionContext containerView];
    
    if (self.animationType == KNavAnimationTypePush) {
        [contentView addSubview:toController.view];
        CGRect fromFrame = fromController.view.frame;
        CGRect toFrame = toController.view.frame;
        
        fromFrame.origin.y = -fromFrame.size.height/2;
        toFrame.origin.y = contentView.frame.size.height;
        [toController.view setFrame:toFrame];
        toFrame.origin.y = 0;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:0.92f
              initialSpringVelocity:17
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [fromController.view setFrame:fromFrame];
                             [toController.view setFrame:toFrame];
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];

    }else{
        [contentView addSubview:toController.view];
        [contentView addSubview:fromController.view];
        
        CGRect fromFrame = fromController.view.frame;
        CGRect toFrame = toController.view.frame;
        
        fromFrame.origin.y = contentView.frame.size.height;
        
        toFrame.origin.y = -contentView.frame.size.height;
        [toController.view setFrame:toFrame];
        toFrame.origin.y = 0;
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:0.92f
              initialSpringVelocity:17
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [fromController.view setFrame:fromFrame];
                             [toController.view setFrame:toFrame];
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];

    }
}
@end
