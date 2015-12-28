//
//  ZJNavAnimationInfoViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/7.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJNavAnimationInfoViewController.h"

@interface ZJNavAnimationInfoViewController ()

@end

@implementation ZJNavAnimationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"转场动画";
    self.view.backgroundColor = [UIColor purpleColor];
    UIImage *infoImage = [UIImage imageNamed:self.imageName];
    UIImageView *infoImageView = [[UIImageView alloc]initWithImage:infoImage];
    infoImageView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    
    CGFloat imageH = (ScreenWidth*infoImage.size.height)/infoImage.size.width;
    infoImageView.bounds = CGRectMake(0, 0, ScreenWidth, imageH);
    infoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:infoImageView];
}

@end
