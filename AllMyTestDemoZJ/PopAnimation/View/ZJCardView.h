//
//  ZJCardView.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/25.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AnimationFinishBlock)();

@interface ZJCardView : UIView


@property (nonatomic,copy)AnimationFinishBlock finishBlock;
/**
 *  显示的card总数
 */
//@property (nonatomic,strong)NSMutableArray *cardsArr;

-(instancetype)initWithFrame:(CGRect)frame finish:(AnimationFinishBlock)finishBlock;



@end
