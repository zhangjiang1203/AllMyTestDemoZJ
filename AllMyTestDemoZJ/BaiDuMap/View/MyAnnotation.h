//
//  MyAnnotation.h
//  地图测试
//
//  Created by zhangjiang on 14/11/10.
//  Copyright (c) 2014年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//#import "BMapKit.h"

@interface MyAnnotation : NSObject<BMKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/**
 *  显示的标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  显示的副标题
 */
@property (nonatomic, copy) NSString *subtitle;
/**
 *  显示的图片
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  定位时间
 */
@property (nonatomic, copy) NSString *lastTime;
/**
 *  弹出泡泡视图的宽度
 */
@property (nonatomic, assign)CGFloat paopaoViewW;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
