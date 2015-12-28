//
//  ZJNavBaseAnimation.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/7.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJNavBaseAnimation.h"

@implementation ZJNavBaseAnimation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.duration = 0.6;
    }
    return self;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSAssert(NO, @"animateTransition: should be handled by subclass of BaseAnimation");
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

-(void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    NSAssert(NO, @"handlePinch: should be handled by a subclass of BaseAnimation");
}
@end
