//
//  ZJAreaModel.h
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/14.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    double areaLatitude;
    double areaLongitude;
} ZJAreaLocation;

@interface ZJAreaModel : NSObject

@property (nonatomic) ZJAreaLocation areaCoordinate;

@property (nonatomic,copy)NSString *areaName;

@property (nonatomic,copy)NSString *areaData;

@property (nonatomic,copy)NSString *areaId;

@property (nonatomic,copy)NSString *areaTime;

-(ZJAreaModel*)initZJAreaWithAreaLatitude:(double)areaLatitude areaLongitude:(double)areaLongitude;

@end
