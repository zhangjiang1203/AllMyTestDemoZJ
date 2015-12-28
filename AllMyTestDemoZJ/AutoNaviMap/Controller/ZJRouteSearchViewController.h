//
//  ZJRouteSearchViewController.h
//  ePark
//
//  Created by zjhaha on 15/12/23.
//  Copyright © 2015年 zjhaha. All rights reserved.
//

#import "ZJBaseViewController.h"

typedef void (^SelectPOIActionBlock)(AMapPOI *selectPOI);

@interface ZJRouteSearchViewController : ZJBaseViewController

@property (strong,nonatomic)AMapGeoPoint *locationPoint;

@property (copy,nonatomic)SelectPOIActionBlock selectedBlock;

@end
