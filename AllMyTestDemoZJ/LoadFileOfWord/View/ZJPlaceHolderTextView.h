//
//  ZJPlaceHolderTextView.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/26.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ZJPlaceHolderTextView : UITextView

@property (nonatomic,copy)IBInspectable NSString *placeHolder;
@property (nonatomic,strong)IBInspectable UIColor *placeColor;
@property (nonatomic,strong)IBInspectable UIFont *placeFont;


@end
