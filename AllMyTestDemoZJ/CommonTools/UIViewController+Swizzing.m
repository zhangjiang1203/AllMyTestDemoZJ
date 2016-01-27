//
//  UIViewController+Swizzing.m
//  ObjCRunTimeTest
//
//  Created by zjhaha on 16/1/27.
//  Copyright © 2016年 zjhaha. All rights reserved.
//

#import "UIViewController+Swizzing.h"
#import <objc/runtime.h>

static char myCount;

@implementation UIViewController (Swizzing)

-(void)setSearchCount:(int)searchCount{
    objc_setAssociatedObject([self class], &myCount, @(searchCount), OBJC_ASSOCIATION_COPY);
}

-(int)searchCount{
    return (int)objc_getAssociatedObject(self, &myCount);
}

+(void)load{
    
    SEL origSel = @selector(viewDidAppear:);
    SEL swizSel = @selector(swiz_viewDidAppear:);
    [UIViewController swizzleMethods:[self class] originalSelector:origSel swizzleSelector:swizSel];
    
}

+(void)swizzleMethods:(Class)class originalSelector:(SEL)origSel swizzleSelector:(SEL)swizSel{
    
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method swizMethod = class_getInstanceMethod(class, swizSel);
    
    BOOL didAddMethod = class_addMethod(class, origSel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else{
        method_exchangeImplementations(origMethod, swizMethod);
    }
    
}


-(void)swiz_viewDidAppear:(BOOL)animated{
    //使用单例来记录某个方法的使用次数,或者使用其他的存取方法记录次数
    NSLog(@"i am in - [swiz_viewDidAppear:] ---%zd",++self.searchCount);
    [self swiz_viewDidAppear:animated];
}
@end
