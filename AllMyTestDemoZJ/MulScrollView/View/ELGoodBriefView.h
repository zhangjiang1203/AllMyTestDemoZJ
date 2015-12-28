//
//  ELGoodBriefView.h
//  eLife
//
//  Created by zhangjiang on 15/7/1.
//  Copyright (c) 2015年 zhangjiang. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KGoodType) {
    KGoodTypeFood = 1,//美食
    KGoodTypeShop= 2,//购物
    KGoodTypeHotel=3,//酒店
    KGoodTypeParent=4,//亲子
    KGoodTypeTravel=5,//旅游
    KGoodTypeLeisure=6,//休闲
    KGoodTypeLife=7,//生活
    KGoodTypeExercise=8//健身
};
@protocol ELGoodBriefViewDelegate <NSObject>

-(void)dragToHiddenNavBar:(BOOL)isHidden;
-(void)clickCellToPush:(NSInteger)index imageName:(NSString*)imageName frame:(CGRect)cellRect;

@end

@interface ELGoodBriefView : UIView
@property (nonatomic,assign)KGoodType goodType;

@property (nonatomic,assign)id <ELGoodBriefViewDelegate>delegate;
@end