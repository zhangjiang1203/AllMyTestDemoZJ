//
//  WCChooseTimeView.h
//  Picker
//
//  Created by pg on 15/9/3.
//  Copyright (c) 2015年 Xhp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCChooseTimeViewDelegate <NSObject>

-(void)chooseRouteStartTime:(NSString*)start endTime:(NSString*)end;

@end


@interface WCChooseTimeView : UIView

@property (nonatomic,assign)id<WCChooseTimeViewDelegate>delegate;

@end
