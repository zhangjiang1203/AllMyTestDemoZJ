//
//  UIView+PopViewAnimation.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/2.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "UIView+PopViewAnimation.h"
static const char popAnimation;
@implementation UIView (PopViewAnimation)

-(void)popAnimationFlyInWithView:(UIView *)popView from:(CGFloat)from to:(CGFloat)to finish:(AnimationSuccessBlock)animationBlock{
    [popView pop_removeAllAnimations];
    
    popView.layer.transform = CATransform3DIdentity;
    [popView.layer setCornerRadius:5.0f];
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI_4/8.0);
    [popView.layer setAffineTransform:rotateTransform];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.springBounciness = 6;
    anim.springSpeed = 10;
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(popView.center.x, to)];
    objc_removeAssociatedObjects(anim);
    anim.delegate = self;
    objc_setAssociatedObject(anim, &popAnimation, animationBlock, OBJC_ASSOCIATION_COPY);
    
    POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnim.duration = 0.25;
    opacityAnim.toValue = @1.0;
    
    POPBasicAnimation *rotationAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnim.beginTime = CACurrentMediaTime() + 0.1;
    rotationAnim.duration = 0.3;
    rotationAnim.toValue = @(0);
    
    [popView pop_addAnimation:anim forKey:@"AnimationScale"];
    [popView.layer pop_addAnimation:opacityAnim forKey:@"AnimateOpacity"];
    [popView.layer pop_addAnimation:rotationAnim forKey:@"AnimateRotation"];
}


-(void)popAnimationFlyOutWithView:(UIView *)popView from:(CGFloat)from to:(CGFloat)to finish:(AnimationSuccessBlock)animationBlock{
    
    [popView pop_removeAllAnimations];
    [popView.layer setCornerRadius:5.0f];
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI_4/8.0);
    [popView.layer setAffineTransform:rotateTransform];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.springBounciness = 6;
    anim.springSpeed = 10;
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(popView.center.x, to)];
    anim.delegate = self;
    objc_removeAssociatedObjects(anim);
    objc_setAssociatedObject(anim, &popAnimation, animationBlock, OBJC_ASSOCIATION_COPY);
    
    POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnim.duration = 0.25;
    opacityAnim.toValue = @0.0;
    
    POPBasicAnimation *rotationAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnim.beginTime = CACurrentMediaTime() + 0.1;
    rotationAnim.duration = 0.3;
    rotationAnim.toValue = @(0);

    [popView pop_addAnimation:anim forKey:@"AnimationScale1"];
    [popView.layer pop_addAnimation:opacityAnim forKey:@"AnimateOpacity1"];
    [popView.layer pop_addAnimation:rotationAnim forKey:@"AnimateRotation1"];

}

/**
 *  动画的代理方法
 */
-(void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished{
    if (finished) {
        AnimationSuccessBlock animation = (AnimationSuccessBlock)objc_getAssociatedObject(anim, &popAnimation);
        animation(finished);
    }
}

@end
