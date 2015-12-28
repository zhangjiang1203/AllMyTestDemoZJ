//
//  ZJAreaModel.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/14.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJAreaModel.h"

@implementation ZJAreaModel

-(ZJAreaModel *)initZJAreaWithAreaLatitude:(double)areaLatitude areaLongitude:(double)areaLongitude{
    self = [super init];
    if (self) {
        _areaCoordinate.areaLatitude = areaLatitude;
        _areaCoordinate.areaLongitude = areaLongitude;
    }
    return self;
}
@end
