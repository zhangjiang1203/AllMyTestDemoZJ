//
//  ZJLocationAnnotation.h
//  ePark
//
//  Created by pg on 15/12/21.
//  Copyright © 2015年 zjhaha. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, LocationAnnotationType)
{
    LocationAnnotationTypeStart,
    LocationAnnotationTypeWay,
    LocationAnnotationTypeEnd
};


@interface ZJLocationAnnotation : NSObject<MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, assign)LocationAnnotationType navPointType;


@end
