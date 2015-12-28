//
//  WCSafeAreaView.h
//  Xiaoxin
//
//  Created by zhangjiang on 15/9/9.
//  Copyright (c) 2015年 juzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  WCSafeAreaViewDelegate<NSObject>
/**
 *  在视图上开始点击
 */
- (void)touchesBegan:(UITouch*)touch;
/**
 *  在视图上开始移动
 */
- (void)touchesMoved:(UITouch*)touch;
/**
 *  在视图上结束移动
 */
- (void)touchesEnded:(UITouch*)touch;
@end


@interface WCSafeAreaView : UIImageView

@property (nonatomic,assign)id<WCSafeAreaViewDelegate>delegate;

@end
