//
//  ZJAnimationChooseView.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/11/30.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AnimationHandleAction)(NSInteger animationType);



@interface ZJAnimationChooseView : UIView

@property (nonatomic,copy)AnimationHandleAction animationAction;

-(instancetype)initWithFrame:(CGRect)frame info:(NSString*)infoStr titles:(NSArray*)titles nameAction:(AnimationHandleAction)animationAction;

@end
