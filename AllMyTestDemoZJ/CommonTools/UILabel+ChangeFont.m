//
//  UILabel+ChangeFont.m
//  AllMyTestDemoZJ
//
//  Created by pg on 16/5/5.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "UILabel+ChangeFont.h"
#import <objc/runtime.h>
#define KCustomFontName @""
@implementation UILabel (ChangeFont)

+(void)load{
    //方法交换应该保证只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获取系统的生命周期方法
        SEL systemSel = @selector(willMoveToSuperview:);
        //自己实现的将要被交换的方法
        SEL swizzSel = @selector(myWillMoveToSuperView:);
        //两个方法的Method
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        //动态添加方法 实现是被交换的方法 返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        }else{
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
        
    });
}

-(void)myWillMoveToSuperView:(UIView*)newSuperView{
    [self myWillMoveToSuperView:newSuperView];
    if (self) {
        if ([UIFont fontNamesForFamilyName:@""]) {
            self.font = [UIFont fontWithName:@"" size:self.font.pointSize];
        }
    }
}

@end
