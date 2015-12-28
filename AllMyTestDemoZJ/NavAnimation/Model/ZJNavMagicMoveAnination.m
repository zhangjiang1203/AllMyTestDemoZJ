//
//  ZJNavMagicMoveAnination.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/8.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJNavMagicMoveAnination.h"

@implementation ZJNavMagicMoveAnination
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *contentView = [transitionContext containerView];
    
    
    [contentView addSubview:toViewController.view];
    [contentView addSubview:fromViewController.view];
    
    if (!_delegate) {
        return;
    }
    //获取代理中的图片和frame
    UIImage *image = [self.delegate snapShotImage:self];
    CGRect imageRect = [self.delegate snapShotClickPosition:self];
    UIImageView *briefImagView = [[UIImageView alloc]initWithImage:image];
    briefImagView.frame = [contentView convertRect:imageRect fromView:fromViewController.view];
    toViewController.view.alpha = 0;
    briefImagView.hidden = NO;
    CGFloat imageH = (ScreenWidth*imageRect.size.height)/imageRect.size.width;
    [contentView addSubview:briefImagView];

    if (self.animationType == KNavAnimationTypePush) {
        //下一个图中显示的图片位置
        fromViewController.view.alpha = 0.0;
        [UIView animateWithDuration:self.duration animations:^{
            briefImagView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
            briefImagView.bounds = CGRectMake(0, 0, ScreenWidth, imageH);
        } completion:^(BOOL finished) {
            briefImagView.hidden = YES;
            toViewController.view.alpha = 1.0;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];

    }else{
        fromViewController.view.alpha = 0.0;
        briefImagView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
        briefImagView.bounds = CGRectMake(0, 0, ScreenWidth, imageH);
        [UIView animateWithDuration:self.duration animations:^{
            briefImagView.frame = [contentView convertRect:imageRect fromView:fromViewController.view];
        } completion:^(BOOL finished) {
            briefImagView.hidden = YES;
            toViewController.view.alpha = 1.0;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    
}

@end
