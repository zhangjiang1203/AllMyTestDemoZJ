//
//  ZJGCDHelper.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/15.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

//队列优先级
typedef NS_ENUM(NSInteger,GlobalQUeuePriority) {
    GlobalQUeuePriorityDefault = 0,
    GlobalQUeuePriorityHight = 2,
    GlobalQUeuePriorityLow = -2,
    GlobalQUeuePriorityBackground = INT16_MIN
};

//阻塞，非阻塞
typedef NS_ENUM(NSInteger,PreformBlockFeature) {
    PreformBlockFeatureChoke,
    PreformBlockFeatureUnchoke
};

//返回值void  block声明
typedef void (^GCDBlock) (void);
typedef void (^GCDBlock1_Size_t) (size_t index);
typedef void (^GCDBlock1_Int)   (int index);

@interface ZJGCDHelper : NSObject

@end
