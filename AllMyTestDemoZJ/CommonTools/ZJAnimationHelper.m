//
//  ZJAnimationHelper.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/26.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJAnimationHelper.h"
static const char popAnimation;
@implementation ZJAnimationHelper

#pragma mark -旋转动画
+(void)setRotationWithAngle:(CGFloat)angle duration:(CGFloat)duration view:(UIView*)animationView{
    POPBasicAnimation *rotation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotation.duration = duration;
    rotation.toValue = @(angle);
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animationView.layer pop_addAnimation:rotation forKey:@"rotation"];
}

+(void)setViewAlpha:(CGFloat)alpha duration:(CGFloat)duration view:(UIView*)animationView{
    POPBasicAnimation *alphaAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnim.toValue = @(alpha);
    alphaAnim.duration = duration;
    alphaAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animationView pop_addAnimation:alphaAnim forKey:@"alpha"];
    
}

+(void)setCenter:(CGPoint)center duration:(CGFloat)duration view:(UIView*)animationView{
    POPBasicAnimation *centerAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    centerAnim.toValue = [NSValue valueWithCGPoint:center];
    centerAnim.duration = duration;
    [centerAnim setCompletionBlock:^(POPAnimation *animation, BOOL is) {
        animationView.hidden = NO;
    }];
    [animationView pop_addAnimation:centerAnim forKey:@"center"];
    
}

+(void)setScale:(CGFloat)present duration:(CGFloat)duration view:(UIView*)animationView{
    POPBasicAnimation *scale = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scale.toValue = [NSValue valueWithCGSize:CGSizeMake(present, present)];
    scale.duration = duration;
    [animationView.layer pop_addAnimation:scale forKey:@"scale"];
}

+(void)makeNumChangeWithView:(UILabel*)label string:(NSString*)suffix FromValue:(CGFloat)from toValue:(CGFloat)to time:(CGFloat)time{
    
    //此对象的属性不在Pop Property的标准属性中，要创建一个POPAnimationProperty
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"countdown" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            label.text = [NSString stringWithFormat:@"%d%@",(int)values[0],suffix];
        };
        prop.threshold = 0.01f;
    }];
    POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];   //秒表当然必须是线性的时间函数
    anBasic.property = prop;    //自定义属性
    anBasic.fromValue = @(from);   //从0开始
    anBasic.toValue = @(to);  //180秒
    anBasic.duration = time;    //持续3分钟
    anBasic.beginTime = CACurrentMediaTime();    //延迟1秒开始
    [label pop_addAnimation:anBasic forKey:@"countdown"];
    
}



+(void)popAnimationFlyInWithView:(UIView *)popView from:(CGFloat)from to:(CGFloat)to finish:(AnimationSuccessBlock)animationBlock{
    [popView pop_removeAllAnimations];
    [[[UIApplication sharedApplication] delegate].window addSubview:popView];
    
    popView.layer.transform = CATransform3DIdentity;
    [popView.layer setCornerRadius:5.0f];
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI_4/8.0);
    [popView.layer setAffineTransform:rotateTransform];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.springBounciness = 6;
    anim.springSpeed = 10;
    anim.fromValue = @(from);
    anim.toValue = @(to);
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
    
    [popView.layer pop_addAnimation:anim forKey:@"AnimationScale"];
    [popView.layer pop_addAnimation:opacityAnim forKey:@"AnimateOpacity"];
    [popView.layer pop_addAnimation:rotationAnim forKey:@"AnimateRotation"];
}


+(void)popAnimationFlyOutWithView:(UIView *)popView from:(CGFloat)from to:(CGFloat)to finish:(AnimationSuccessBlock)animationBlock{
    
    
    [popView pop_removeAllAnimations];
    
    [popView.layer setCornerRadius:5.0f];
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(-M_PI_4/8.0);
    [popView.layer setAffineTransform:rotateTransform];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.springBounciness = 6;
    anim.springSpeed = 10;
    anim.fromValue = @(from);
    anim.toValue = @(to);
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
    
    [popView.layer pop_addAnimation:anim forKey:@"AnimationScale1"];
    [popView.layer pop_addAnimation:opacityAnim forKey:@"AnimateOpacity1"];
    [popView.layer pop_addAnimation:rotationAnim forKey:@"AnimateRotation1"];
    [popView removeFromSuperview];
    
}

-(void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished{
    if (finished) {
        AnimationSuccessBlock animation = (AnimationSuccessBlock)objc_getAssociatedObject(anim, &popAnimation);
        animation(finished);
    }
}

@end
