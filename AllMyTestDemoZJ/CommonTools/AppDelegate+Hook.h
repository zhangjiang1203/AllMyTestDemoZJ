//
//  HUDHelper+Hook.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/14.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "AppDelegate.h"

/**
 *  交换两个方法的实行
 */
void exchangeMethod(Class aclass,SEL originSEL,SEL swizzledSEL){
    
    
    Method originMethod = class_getInstanceMethod(aclass, originSEL);
    Method swizzledMethod = nil;
    
    if (!originMethod)
    {// 处理为类方法
        originMethod = class_getClassMethod(aclass, originSEL);
        if (!originMethod)
        {
            return;
        }
        swizzledMethod = class_getClassMethod(aclass, swizzledSEL);
        if (!swizzledMethod)
        {
            return;
        }
    }
    else
    {// 处理实例方法
        swizzledMethod = class_getInstanceMethod(aclass, swizzledSEL);
        if (!swizzledMethod)
        {
            return;
        }
    }
    
    if(class_addMethod(aclass, originSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)))
    { //自身已经有了就添加不成功，直接交换即可
        class_replaceMethod(aclass, swizzledSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }
    else
    {
        method_exchangeImplementations(originMethod, swizzledMethod);
    }
}

@interface AppDelegate (Hook)

@end
