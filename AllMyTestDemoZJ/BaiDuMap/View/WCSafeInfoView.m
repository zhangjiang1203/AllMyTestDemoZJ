//
//  WCSafeInfoView.m
//  Xiaoxin
//
//  Created by zhangjiang on 15/9/11.
//  Copyright (c) 2015年 juzi. All rights reserved.
//

#import "WCSafeInfoView.h"
#define KBottomH 75
#define KButtonH 35
#define KButtonTag 10
@implementation WCSafeInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KRGBA(0, 0, 0, 0);
        [self addBottomView];
    }
    return self;
}

-(void)addBottomView{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - KBottomH, ScreenWidth, KBottomH)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    NSArray *titleArr = @[@"删除",@"重新设置"];
    //添加按钮和分割线
    for (int i = 0; i< titleArr.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, KButtonH*i+1, ScreenWidth, 35)];
        [button setTitleColor:KRGBA(245, 115, 76, 1) forState:UIControlStateNormal];
        button.tag = i + KButtonTag;
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseCurrentButton:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
        
        if (i < 2) {
            //添加分割线
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (KButtonH+1)*(i+1), ScreenWidth, 1)];
            lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [bottomView addSubview:lineLabel];
        }
        
    }
}

-(void)chooseCurrentButton:(UIButton*)sender{
    NSInteger index = sender.tag -KButtonTag;
    if ([self.delegate respondsToSelector:@selector(selectedActionIndex:)]) {
        [self.delegate selectedActionIndex:index];
    }
    [self removeInfoViewFromSuperView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self]; //返回触摸点在视图中的当前坐标
    if (point.y < self.frame.size.height - KBottomH) {
        [self removeInfoViewFromSuperView];
    }
}

-(void)removeInfoViewFromSuperView{
    
    [UIView animateWithDuration:0.4 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:1.0 // 类似弹簧振动效果 0~1
          initialSpringVelocity:5.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         self.frame = CGRectMake(0, 2*ScreenWidth, ScreenWidth, ScreenHeight);
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}



@end
