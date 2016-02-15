//
//  MaskAnimation.m
//  UIBezierPathTest
//
//  Created by zjhaha on 16/2/15.
//  Copyright © 2016年 zjhaha. All rights reserved.
//

#import "MaskAnimation.h"

@interface MaskAnimation ()
@property(nonatomic,strong)id<UIViewControllerContextTransitioning>transitionContext;
@property (strong,nonatomic)UIView *bubbleView;

@end

@implementation MaskAnimation

//-(UIView *)bubbleView{
//    if (_bubbleView == nil) {
//        
//        _bubbleView = [[UIView alloc]init];
//    }
//    return _bubbleView;
//}


-(void)setStartPoint:(CGPoint)startPoint{
    _startPoint = startPoint;
    self.bubbleView.center = _startPoint;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIView *containerView = [transitionContext containerView];
    self.transitionContext = transitionContext;
    if (self.animationType == KViewControllerPresent) {
        _bubbleView = [[UIView alloc]init];
        self.bubbleView.backgroundColor = [UIColor greenColor];
        CGSize originalSize = [[UIScreen mainScreen]bounds].size;
        UIView *presentView = [transitionContext viewForKey:UITransitionContextToViewKey];
        presentView.frame = CGRectMake(0, 0, originalSize.width,originalSize.height);
        CGPoint originalCenter = presentView.center;
        
        self.bubbleView.frame = [self getBubbleFrameWithCenter:originalCenter size:originalSize start:_startPoint];
        self.bubbleView.layer.cornerRadius = self.bubbleView.frame.size.height/2;
        self.bubbleView.center = _startPoint;
        self.bubbleView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        [containerView addSubview:self.bubbleView];
        
        presentView.backgroundColor = [UIColor greenColor];
        
        presentView.center = _startPoint;
        presentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        presentView.alpha = 0;
        [containerView addSubview:presentView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            _bubbleView.transform = CGAffineTransformIdentity;
            presentView.transform = CGAffineTransformIdentity;
            presentView.alpha = 1;
            presentView.center = originalCenter;
            
        } completion:^(BOOL finished) {
            [self.transitionContext completeTransition:YES];
        }];
        
        
    }else{
        NSString *key = (_animationType == KViewControllerPop) ? UITransitionContextToViewKey : UITransitionContextFromViewKey;
        UIView *dismissView = [transitionContext viewForKey:key];
        CGPoint originalPoint = dismissView.center;
        CGSize originalSize = [[UIScreen mainScreen]bounds].size;
        
        self.bubbleView.frame = [self getBubbleFrameWithCenter:originalPoint size:originalSize start:_startPoint];
        self.bubbleView.layer.cornerRadius = _bubbleView.frame.size.height/2;
        self.bubbleView.center = _startPoint;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            _bubbleView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            dismissView.transform = CGAffineTransformMakeScale(0.001, 0.001);
            dismissView.center = _startPoint;
            dismissView.alpha = 0;
            
            if (_animationType == KViewControllerPop) {
                [containerView insertSubview:dismissView belowSubview:dismissView];
                [containerView insertSubview:_bubbleView belowSubview:dismissView];
            }
            
        } completion:^(BOOL finished) {
            [self.transitionContext completeTransition:YES];

        }];
       
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    self.bubbleView = nil;
}

//返回的rect
-(CGRect)getBubbleFrameWithCenter:(CGPoint)center size:(CGSize)size start:(CGPoint)start{
    
    double lengthX = fmax(start.x, size.width - start.x);
    double lengthY = fmax(start.y, size.height - start.y);
    double offset = sqrt(lengthX*lengthX+lengthY*lengthY)*2;
    return CGRectMake(0, 0, offset, offset);
}

@end
