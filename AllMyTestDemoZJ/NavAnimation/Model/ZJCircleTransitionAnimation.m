//
//  ZJCircleTransitionAnimation.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/8.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJCircleTransitionAnimation.h"

@interface ZJCircleTransitionAnimation ()

@property(nonatomic,strong)id<UIViewControllerContextTransitioning>transitionContext;

@end

@implementation ZJCircleTransitionAnimation

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    self.transitionContext = transitionContext;
    
//    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *contentView = [transitionContext containerView];
    
    CGRect buttonRect = CGRectMake(300, 20, 30, 30);
    UIButton *button = [[UIButton alloc]initWithFrame:buttonRect];
    [contentView addSubview:toViewController.view];
    
    UIBezierPath *circleStartPath = [UIBezierPath bezierPathWithOvalInRect:buttonRect];
    CGPoint extremPoint = CGPointMake(button.center.x - 0, button.center.y + CGRectGetHeight(toViewController.view.bounds));
    CGFloat radius = sqrtf((extremPoint.x *extremPoint.x)+(extremPoint.y*extremPoint.y));
    UIBezierPath *circleFinalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(buttonRect, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.path = circleFinalPath.CGPath;
    toViewController.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id _Nullable)(circleStartPath.CGPath);
    maskLayerAnimation.toValue = (__bridge id _Nullable)(circleFinalPath.CGPath);
    maskLayerAnimation.duration = self.duration;
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    
}
@end
