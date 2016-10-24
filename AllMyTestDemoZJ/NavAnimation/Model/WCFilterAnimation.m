//
//  WCFilterAnimation.m
//  Xiaoxin
//
//  Created by zhangjiang on 15/7/29.
//  Copyright (c) 2015年 juzi. All rights reserved.
//

#import "WCFilterAnimation.h"

@interface WCFilterAnimation ()<CAAnimationDelegate>
@property(nonatomic,strong)id<UIViewControllerContextTransitioning>transitionContext;

@end

@implementation WCFilterAnimation

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;
    if (self.animationType == KNavAnimationTypePush) {
        [self animateForPush:transitionContext];
    }else{
        [self animateForPop:transitionContext];
    }
}

-(void)animateForPush:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *contentView = [transitionContext containerView];
    
    if (!_delegate) {//有代理传值
        return;
    }
    CGRect buttonFrame = [self.delegate filterButtonPosition:self];
    
//    UIButton *abutton = [[UIButton alloc]initWithFrame:CGRectMake(buttonFrame.origin.x, buttonFrame.origin.y, buttonFrame.size.width, buttonFrame.size.height)];
//    abutton.backgroundColor = [UIColor clearColor];
//    abutton.alpha = 1;
//    abutton.layer.cornerRadius = buttonFrame.size.width/2;
//    [toVC.view addSubview:abutton];
//    
//    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
//        abutton.transform = CGAffineTransformScale(abutton.transform, 0.1, 0.1);
//        abutton.alpha = 0;
//    } completion:^(BOOL finished) {
//    }];
    
    
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithOvalInRect:buttonFrame];
    if (fromVC.edgesForExtendedLayout==UIRectEdgeNone) {
        fromVC.view.frame= CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
        toVC.view.frame= CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
    }else
    {
        fromVC.view.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        toVC.view.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    [contentView addSubview:fromVC.view];
    [contentView addSubview:toVC.view];
    
    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        abutton.transform = CGAffineTransformScale(abutton.transform, 0.1, 0.1);
//    } completion:^(BOOL finished) {
//        if (finished) {
//            abutton.transform = CGAffineTransformIdentity;
//        }
//    }];
    
    
    //创建两个圆形的 UIBezierPath 实例；一个是 button 的 size ，另外一个则拥有足够覆盖屏幕的半径。最终的动画则是在这两个贝塞尔路径之间进行的
    
    CGPoint finalPoint;
    //判断触发点在那个象限
    if(buttonFrame.origin.x > (toVC.view.bounds.size.width / 2)){
        if (buttonFrame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第一象限
            finalPoint = CGPointMake(buttonFrame.origin.x/2 - 0, buttonFrame.origin.y/2 - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第四象限
            finalPoint = CGPointMake(buttonFrame.origin.x/2 - 0, buttonFrame.origin.y/2 - 0);
        }
    }else{
        if (buttonFrame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第二象限
            finalPoint = CGPointMake(buttonFrame.origin.x/2 - CGRectGetMaxX(toVC.view.bounds), buttonFrame.origin.y/2 - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第三象限
            finalPoint = CGPointMake(buttonFrame.origin.x/2 - CGRectGetMaxX(toVC.view.bounds), buttonFrame.origin.y/2 - 0);
        }
    }
    
    
    
    CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(buttonFrame, -radius, -radius)];
    
    
    //创建一个 CAShapeLayer 来负责展示圆形遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalBP.CGPath; //将它的 path 指定为最终的 path 来避免在动画完成后会回弹
    toVC.view.layer.mask = maskLayer;
    
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = self.duration;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];

}

-(void)animateForPop:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    if (!_delegate) {//有代理传值
        return;
    }
    CGRect buttonFrame = [self.delegate filterButtonPosition:self];
//    //根据frame创建一个按钮
//    UIButton *abutton = [[UIButton alloc]initWithFrame:buttonFrame];
//    abutton.backgroundColor = [UIColor clearColor];
//    abutton.layer.cornerRadius = buttonFrame.size.width/2;
//    abutton.alpha = 0;
//    abutton.transform = CGAffineTransformScale(abutton.transform, 0.1, 0.1);
//    [fromVC.view addSubview:abutton];
//    
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        abutton.alpha = 1;
//        abutton.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//        abutton.alpha = 0;
//    }];
    
    if (fromVC.edgesForExtendedLayout==UIRectEdgeNone) {
        fromVC.view.frame= CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
        toVC.view.frame= CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
    }else
    {
        fromVC.view.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        toVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }

    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:buttonFrame];
    CGPoint finalPoint;
    
    //判断触发点在那个象限
    if(buttonFrame.origin.x > (toVC.view.bounds.size.width / 2)){
        if (buttonFrame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第一象限
            finalPoint = CGPointMake(buttonFrame.origin.x/2 - 0, buttonFrame.origin.y/2 - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第四象限
            finalPoint = CGPointMake(buttonFrame.origin.x/2 - 0, buttonFrame.origin.y/2 - 0);
        }
    }else{
        if (buttonFrame.origin.y < (toVC.view.bounds.size.height / 2)) {
            //第二象限
            finalPoint = CGPointMake(buttonFrame.origin.x/2 - CGRectGetMaxX(toVC.view.bounds), buttonFrame.origin.y/2 - CGRectGetMaxY(toVC.view.bounds)+30);
        }else{
            //第三象限
            finalPoint = CGPointMake(buttonFrame.origin.x/2 - CGRectGetMaxX(toVC.view.bounds), buttonFrame.origin.y/2 - 0);
        }
    }
    
    CGFloat radius = sqrt(finalPoint.x * finalPoint.x + finalPoint.y * finalPoint.y);
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(buttonFrame, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = finalPath.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    
    CABasicAnimation *pingAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pingAnimation.fromValue = (__bridge id)(startPath.CGPath);
    pingAnimation.toValue   = (__bridge id)(finalPath.CGPath);
    pingAnimation.duration = self.duration;
    pingAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    pingAnimation.delegate = self;
    
    [maskLayer addAnimation:pingAnimation forKey:@"pingInvert"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
    
}

@end
