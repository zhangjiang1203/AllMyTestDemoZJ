//
//  HUDHelper+Hook.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/14.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "AppDelegate+Hook.h"



@implementation HUDHelper (Hook)

+(void)hook{
    exchangeMethod([self class], @selector(showLabelHUDOnScreen), @selector(hook_showLabelHUDOnScreen));
}

+(void)load{
    [self hook];
}
- (void)hook_showLabelHUDOnScreen
{
    NSLog(@"代码被执行");

}

@end
