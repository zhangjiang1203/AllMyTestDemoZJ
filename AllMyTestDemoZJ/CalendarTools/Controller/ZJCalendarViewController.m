//
//  ZJCalendarViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/1.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJCalendarViewController.h"
#import "UIView+PopViewAnimation.h"
@interface ZJCalendarViewController ()

@property (strong,nonatomic)UIView *testView;

@property (strong,nonatomic)UIView *backTestView;
@end

@implementation ZJCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日历选择";
    self.view.clipsToBounds = YES;
    [self setRightButtonItem];
    
    
    self.backTestView = [[UIView alloc]initWithFrame:CGRectMake(-(ScreenWidth-150), 0, ScreenWidth-150, ScreenHeight - 64)];
    self.backTestView.backgroundColor = [UIColor redColor];
    
    UIPanGestureRecognizer *swipeReco1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(showViewFromRight:)];
//    swipeReco1.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.backTestView addGestureRecognizer:swipeReco1];
    [self.view addSubview:self.backTestView];
    
    UISwipeGestureRecognizer *swipeReco = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showViewFromLeft:)];
    swipeReco.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeReco];
    
}


-(void)showViewFromLeft:(UISwipeGestureRecognizer*)recognizer{
    CGPoint location = [recognizer locationInView:self.view];
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (location.x < 10) {
            [UIView animateWithDuration:0.1 animations:^{
                self.backTestView.frame = CGRectMake(0, 0, ScreenWidth-150, ScreenHeight-64);
            }];
            
        }
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            self.backTestView.frame = CGRectMake(-(ScreenWidth-150), 0, ScreenWidth-150, ScreenHeight-64);
        }];
    }
  
}

-(void)showViewFromRight:(UIPanGestureRecognizer*)recognizer{
    
    CGPoint translation = [recognizer translationInView:self.view];
    CGFloat translationX = recognizer.view.frame.origin.x + translation.x;
    if (translationX >= 0) {
        translationX = 0;
    }
    
    if (translationX < -(ScreenWidth-150)/2) {
        translationX = -(ScreenWidth-150);
    }
    
    
//    recognizer.view.center = CGPointMake(translationX,recognizer.view.center.y);
    [UIView animateWithDuration:0.3 animations:^{
        recognizer.view.frame = CGRectMake(translationX, 0, ScreenWidth-150, ScreenHeight - 64);
    }];
    
}

-(void)setRightButtonItem{
    UIButton *rigthBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [rigthBtn setTitle:@"动画" forState:UIControlStateNormal];
    rigthBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rigthBtn addTarget:self action:@selector(areaListView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rigthBtn];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
     *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -7;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, right];
}

#pragma mark -动画改变视图
-(void)areaListView:(UIButton*)sender{
    
    sender.selected = !sender.selected;
    sender.enabled = NO;
    if (sender.selected) {
        [self addAnimationView];
        [self.testView popAnimationFlyInWithView:self.testView from:-200 to:self.view.center.y - 64 finish:^(BOOL isFinish) {
            NSLog(@"执行完毕1");
            sender.enabled = YES;
        }];
    }else{
        [self.testView popAnimationFlyOutWithView:self.testView from:self.view.center.y - 64 to:-200 finish:^(BOOL isFinish) {
            NSLog(@"执行完毕2");
            sender.enabled = YES;
            [self.testView removeFromSuperview];
        }];
    }
}


-(void)addAnimationView{
    self.testView = [[UIView alloc]initWithFrame:CGRectMake(20.0f, 0.0f, ScreenWidth-40.0f, 300.0f)];
    self.testView.layer.opacity = 0.0;
    self.testView.layer.transform = CATransform3DIdentity;
    [self.testView.layer setMasksToBounds:YES];
    [self.testView.layer setBackgroundColor:[UIColor colorWithRed:0.16 green:0.72 blue:1.0 alpha:1.0].CGColor];
    [self.testView.layer setCornerRadius:25.0f];
    
    [self.view addSubview:self.testView];
}

@end
