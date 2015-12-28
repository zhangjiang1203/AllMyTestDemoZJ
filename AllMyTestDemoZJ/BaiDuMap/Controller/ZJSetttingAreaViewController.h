//
//  ZJSetttingAreaViewController.h
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/11.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJBaseViewController.h"

#pragma mark - 两种枚举类型
typedef NS_ENUM(NSInteger,KSafeAreaType) {
    KSafeAreaTypeAdd    = 0,
    KSafeAreaTypeChange = 1,

};


@interface ZJSetttingAreaViewController : ZJBaseViewController

@property (assign,nonatomic)KSafeAreaType safeType;

/**
 *  修改模式下才用到这个参数
 */
@property (nonatomic,strong)ZJAreaModel *areaChangeModel;

@end
