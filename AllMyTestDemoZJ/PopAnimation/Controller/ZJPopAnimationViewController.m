//
//  ZJPopAnimationViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/25.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJPopAnimationViewController.h"
#import "ZJCardView.h"
#import "ZJCircleView.h"
#define KAnimationTime 0.25
#define KPaddingLeft 8
@interface ZJPopAnimationViewController ()

@property (nonatomic,strong)NSMutableArray *viewsArr;


//@property (nonatomic,strong)ZJCircleView *circleView;
@end

@implementation ZJPopAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewsArr = [NSMutableArray array];
    
#pragma mark -代码添加circleView
//    _circleView = [[ZJCircleView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
//    _circleView.center = self.view.center;
//    _circleView.circlePercentage = 0.9;
//    _circleView.circleWidth = 4;
//    _circleView.titleColor = KRGBA(55, 76, 155, 1);
//    [self.view addSubview:_circleView];
    [self addMyCardView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panChange:)];
    [self.view addGestureRecognizer:pan];

}

-(void)addMyCardView{
    for (int i = 0; i<4; i++) {
        ZJCardView *cardView = [[[NSBundle mainBundle]loadNibNamed:@"ZJCardView" owner:nil options:nil]lastObject];
        cardView.backgroundColor = [UIColor whiteColor];
        cardView.bounds = CGRectMake(0, 0, 240, 300);
        cardView.center = CGPointMake(ScreenWidth/2, 200+i*KPaddingLeft);
        [ZJAnimationHelper setCenter:CGPointMake(ScreenWidth/2, 200+i*KPaddingLeft) duration:KAnimationTime view:cardView];
        [ZJAnimationHelper setScale:1+i*0.01 duration:KAnimationTime view:cardView];
        [self.view addSubview:cardView];
        [self.viewsArr addObject:cardView];
    }

}


-(void)panChange:(UIPanGestureRecognizer*)recongizer{
    
    if (!self.viewsArr.count) {
        return;
    }
    
    ZJCardView *cardView = self.viewsArr[self.viewsArr.count-1];
    CGPoint point = [recongizer translationInView:cardView];
    cardView.center = CGPointMake(cardView.center.x+point.x, cardView.center.y+point.y);
    //偏移的百分比
    CGFloat XOffPercent = (cardView.center.x-CGRectGetWidth(self.view.bounds)/2)/(CGRectGetWidth(self.view.bounds)/2);
    CGFloat rotationAngle = M_PI_2/4*XOffPercent;
    CGFloat alpha = fabs(rotationAngle);
    if (rotationAngle>0) {
        cardView.showFlagTitleLabel.hidden = NO;
        cardView.showFlagImage.hidden = NO;
        cardView.showFlagImage.image = [UIImage imageNamed:@"shoucang"];
        cardView.showFlagTitleLabel.text = @"感兴趣";
        cardView.showFlagTitleLabel.textColor = KRGBA(70, 198, 88, 1);
        
    }else{
        cardView.showFlagImage.image = [UIImage imageNamed:@"delete"];
        cardView.showFlagTitleLabel.text = @"暂不考虑";
        cardView.showFlagTitleLabel.textColor = KRGBA(198, 70, 88, 1);
        cardView.showFlagTitleLabel.hidden = NO;
        cardView.showFlagImage.hidden = NO;
    }
    
    NSLog(@"添加上变化的值---%f",alpha);
    [ZJAnimationHelper setViewAlpha:alpha+0.4 duration:0.001f view:cardView.showFlagImage];
    [ZJAnimationHelper setViewAlpha:alpha+0.4 duration:0.001f view:cardView.showFlagTitleLabel];
//    [self setViewAlpha:(1-alpha) duration:0.001f view:cardView];
    [ZJAnimationHelper setRotationWithAngle:rotationAngle duration:0.001f view:cardView];
    //重置刚才的那个point为零
    [recongizer setTranslation:CGPointZero inView:self.view];
    
    if (recongizer.state == UIGestureRecognizerStateEnded){
        if (cardView.center.x > 60 && cardView.center.x<CGRectGetWidth(self.view.bounds)-60) {
            //回到原来的位置
            [ZJAnimationHelper setViewAlpha:1 duration:0.001f view:cardView];
            [ZJAnimationHelper setRotationWithAngle:0 duration:0.001f view:cardView];
            CGPoint centerP = CGPointMake(CGRectGetWidth(self.view.frame)/2, 200+3*5);
            [ZJAnimationHelper setCenter:centerP duration:0.15 view:cardView];
            cardView.showFlagTitleLabel.hidden = YES;
            cardView.showFlagImage.hidden = YES;
            
        }else{
            //删除view下一个view替换
            if (rotationAngle > 0) {
                //表示喜欢这个，添加到喜欢栏
                NSLog(@"对这个感兴趣");
            }
            [cardView removeFromSuperview];
            [self.viewsArr removeLastObject];
            if (self.viewsArr.count > 0) {
                ZJCardView *view1 = self.viewsArr[self.viewsArr.count-1];
                [ZJAnimationHelper setCenter:CGPointMake(ScreenWidth/2, 200+3*KPaddingLeft) duration:KAnimationTime view:view1];
            }else{
                //删除完毕之后在请求数据
                NSLog(@"最后一张");
                [self addMyCardView];
            }
        }
    }
    
}


//获取随机颜色
-(UIColor*)getRandomColor{
    CGFloat red   = arc4random()%255;
    CGFloat blue  = arc4random()%255;
    CGFloat green = arc4random()%255;
    
    return KRGBA(red, blue, green, 1);
}

@end
