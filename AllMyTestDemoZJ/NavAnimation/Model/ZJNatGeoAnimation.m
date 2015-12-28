//
//  ZJNatGeoAnimation.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/8.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJNatGeoAnimation.h"
static const CGFloat kAnimationFirstPartRatio = 0.8f;
@implementation ZJNatGeoAnimation

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *contentView = [transitionContext containerView];
    [contentView addSubview:fromController.view];
    [contentView addSubview:toController.view];
    
    CALayer *fromLayer,*toLayer;
    
    if (self.animationType == KNavAnimationTypePush) {
        toController.view.userInteractionEnabled = YES;
        
        fromLayer = toController.view.layer;
        toLayer = fromController.view.layer;
        
        //初始化旋转
        sourceLastTransform(fromLayer);
        destinationLastTransform(toLayer);
        
        //执行动画
        [UIView animateKeyframesWithDuration:self.duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:kAnimationFirstPartRatio animations:^{
                sourceFirstTransform(fromLayer);
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
                destinationFirstTransform(toLayer);
            }];
            
        } completion:^(BOOL finished) {
            //完成之后移除fromLayer 和toLayer
            if ([transitionContext transitionWasCancelled]) {
                [contentView bringSubviewToFront:fromController.view];
                toController.view.userInteractionEnabled = NO;
            }
            
            fromController.view.layer.transform = CATransform3DIdentity;
            toController.view.layer.transform = CATransform3DIdentity;
            contentView.layer.transform = CATransform3DIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }else{
        
        fromController.view.userInteractionEnabled = NO;
        fromLayer = fromController.view.layer;
        toLayer = toController.view.layer;
        
        CGRect oldFrame = fromLayer.frame;
        [fromLayer setAnchorPoint:CGPointMake(0.0, 0.5)];
        [fromLayer setFrame:oldFrame];
        
        sourceFirstTransform(fromLayer);
        destinationFirstTransform(toLayer);
        
        [UIView animateKeyframesWithDuration:self.duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
                destinationLastTransform(toLayer);
            }];
            
            [UIView addKeyframeWithRelativeStartTime:(1.0 - kAnimationFirstPartRatio) relativeDuration:kAnimationFirstPartRatio animations:^{
                sourceLastTransform(fromLayer);
            }];
        } completion:^(BOOL finished) {
            //完成之后移除fromLayer 和toLayer
            if ([transitionContext transitionWasCancelled]) {
                [contentView bringSubviewToFront:fromController.view];
                fromController.view.userInteractionEnabled = YES;
            }
            
            fromController.view.layer.transform = CATransform3DIdentity;
            toController.view.layer.transform = CATransform3DIdentity;
            contentView.layer.transform = CATransform3DIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    
    
}



#pragma mark - Required 3d Transform
static void sourceFirstTransform(CALayer *layer) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -500;
    t = CATransform3DTranslate(t, 0.0f, 0.0f, 0.0f);
    layer.transform = t;
}

static void sourceLastTransform(CALayer *layer) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -500.0f;
    t = CATransform3DRotate(t, radianFromDegree(80), 0.0f, 1.0f, 0.0f);
    t = CATransform3DTranslate(t, 0.0f, 0.0f, -30.0f);
    t = CATransform3DTranslate(t, 170.0f, 0.0f, 0.0f);
    layer.transform = t;
}

static void destinationFirstTransform(CALayer * layer) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0f / -500.0f;
    // Rotate 5 degrees within the axis of z axis
    t = CATransform3DRotate(t, radianFromDegree(5.0f), 0.0f, 0.0f, 1.0f);
    // Reposition toward to the left where it initialized
    t = CATransform3DTranslate(t, 320.0f, -40.0f, 150.0f);
    // Rotate it -45 degrees within the y axis
    t = CATransform3DRotate(t, radianFromDegree(-45), 0.0f, 1.0f, 0.0f);
    // Rotate it 10 degrees within thee x axis
    t = CATransform3DRotate(t, radianFromDegree(10), 1.0f, 0.0f, 0.0f);
    layer.transform = t;
}

static void destinationLastTransform(CALayer * layer) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/ -500;
    // Rotate to 0 degrees within z axis
    t = CATransform3DRotate(t, radianFromDegree(0), 0.0f, 0.0f, 1.0f);
    // Bring back to the final position
    t = CATransform3DTranslate(t, 0.0f, 0.0f, 0.0f);
    // Rotate 0 degrees within y axis
    t = CATransform3DRotate(t, radianFromDegree(0), 0.0f, 1.0f, 0.0f);
    // Rotate 0 degrees within  x axis
    t = CATransform3DRotate(t, radianFromDegree(0), 1.0f, 0.0f, 0.0f);
    layer.transform = t;
}

#pragma mark - Convert Degrees to Radian
static double radianFromDegree(float degrees) {
    return (degrees / 180) * M_PI;
}
@end
