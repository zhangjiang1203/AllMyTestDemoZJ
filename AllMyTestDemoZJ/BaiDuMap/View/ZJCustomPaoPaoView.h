//
//  ZJCustomPaoPaoView.h
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/10.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAnnotation.h"
typedef void (^OnClickHandle)();

@interface ZJCustomPaoPaoView : UIView

@property (strong,nonatomic)MyAnnotation *customAnno;

@property (nonatomic,copy)OnClickHandle clickhandle;

-(instancetype)initWithFrame:(CGRect)frame onClick:(OnClickHandle)clickBlock;
@end
