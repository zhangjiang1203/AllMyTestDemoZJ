//
//  ZJBaseNavViewController.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/6.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJBaseNavViewController.h"

@interface ZJBaseNavViewController ()

@end

@implementation ZJBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navBar = [UINavigationBar appearance];    
    [navBar setBarTintColor:KRGBA(20, 115, 213, 1)];
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,KDefaultFont(18),NSFontAttributeName,nil]];
    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
