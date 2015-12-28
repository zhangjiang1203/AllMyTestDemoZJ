//
//  WCSafeInfoView.h
//  Xiaoxin
//
//  Created by zhangjiang on 15/9/11.
//  Copyright (c) 2015年 juzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCSafeInfoViewDelegate <NSObject>

-(void)selectedActionIndex:(NSInteger)selectedIndex;

@end

@interface WCSafeInfoView : UIView

@property (nonatomic,strong)id<WCSafeInfoViewDelegate>delegate;

@end
