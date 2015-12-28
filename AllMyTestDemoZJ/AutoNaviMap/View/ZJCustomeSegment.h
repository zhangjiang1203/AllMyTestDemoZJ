//
//  ZJCustomeSegment.h
//  CostumeSegmentDome
//
//  Created by zjhaha on 15/12/28.
//  Copyright © 2015年 zjhaha. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionHandlerClick)(NSString *titleName,NSInteger selectIndex);

@interface ZJCustomeSegment : UIView
/**
 *  segment Title
 */
@property (strong,nonatomic)NSArray *titleArr;

/**
 *  默认字体
 */
@property (strong,nonatomic)UIFont *defaultTitleFont;

/**
 *  高亮字体的大小
 */
@property (strong,nonatomic)UIFont *heightTitleFont;

/**
 *  默认文字颜色
 */
@property (strong,nonatomic)UIColor *defaultTitleColor;

/**
 *  高亮文字颜色
 */
@property (strong,nonatomic)UIColor *heightColor;

/**
 *  动画视图背景上
 */
@property (strong,nonatomic)UIColor *backImageColor;

/**
 *  点击按钮的回调
 *
 *  @param block 点击按钮的Block
 */
-(void) setButtonOnClickBlock:(ActionHandlerClick) block;

@end
