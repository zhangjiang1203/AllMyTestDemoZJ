//
//  ZJSafeNameView.h
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/25.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SafeNameHandleAction)(NSString *safeName,BOOL isDismiss);

@interface ZJSafeNameView : UIView

@property (nonatomic,copy)SafeNameHandleAction nameHandleAction;

@property (nonatomic,copy)NSString *areaNameStr;

-(instancetype)initWithFrame:(CGRect)frame nameAction:(SafeNameHandleAction)nameHandleAction;

@end
