//
//  ZJBaseViewController.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/6.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJBaseViewController.h"

@interface ZJBaseViewController ()

@end

@implementation ZJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [self setLeftButtonItem];
    
}


#pragma mark -直接返回上一层
-(void)setLeftButtonItem{
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 11, 20)];
    [back setImage:[UIImage imageNamed:@"back_press_base"] forState:UIControlStateNormal];
    back.imageView.contentMode = UIViewContentModeLeft;
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
     *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -7;
    
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, left];
}
-(void)back{
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{        
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
@end
