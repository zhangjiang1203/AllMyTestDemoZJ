//
//  ZJNavMagicMoveAnination.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/8.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJNavBaseAnimation.h"
@class ZJNavMagicMoveAnination;
@protocol ZJNavMagicMoveAninationDelegate <NSObject>

-(UIImage*)snapShotImage:(ZJNavMagicMoveAnination*)magicAnimation;

-(CGRect)snapShotClickPosition:(ZJNavMagicMoveAnination*)magicAnimation;

@end

@interface ZJNavMagicMoveAnination : ZJNavBaseAnimation

@property (assign,nonatomic)id<ZJNavMagicMoveAninationDelegate>delegate;

@end
