//
//  MaskAnimation.h
//  UIBezierPathTest
//
//  Created by zjhaha on 16/2/15.
//  Copyright © 2016年 zjhaha. All rights reserved.
//


#pragma mark -设置secondView跳转方法示例
//SecondViewController *vc = [[SecondViewController alloc]initWithNibName:@"SecondViewController" bundle:nil];
//vc.transitioningDelegate = self;
//vc.modalPresentationStyle = UIModalPresentationCustom;
//[self presentViewController:vc animated:YES completion:nil];

//代理方法中还要设置返回的类型和点击的中心点的位置

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    KViewControllerPresent,
    KViewControllerDismiss,
    KViewControllerPop
}KViewControllerType;

@interface MaskAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign)CGPoint startPoint;

@property (nonatomic, assign) KViewControllerType animationType;

@end
