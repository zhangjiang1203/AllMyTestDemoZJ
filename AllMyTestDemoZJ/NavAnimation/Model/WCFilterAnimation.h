//
//  WCFilterAnimation.h
//  Xiaoxin
//
//  Created by zhangjiang on 15/7/29.
//  Copyright (c) 2015年 juzi. All rights reserved.
//

#import "ZJNavBaseAnimation.h"
@class WCFilterAnimation;
@protocol WCFilterAnimationDelegate <NSObject>
//根据按钮的位置传递点击的位置信息
-(CGRect)filterButtonPosition:(WCFilterAnimation*)filterAnimation;

@end

@interface WCFilterAnimation : ZJNavBaseAnimation

//传递frame的代理方法
@property (nonatomic,assign)id<WCFilterAnimationDelegate>delegate;


@end
