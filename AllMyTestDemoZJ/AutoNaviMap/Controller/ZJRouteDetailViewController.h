//
//  ZJRouteDetailViewController.h
//  ePark
//
//  Created by zjhaha on 15/12/22.
//  Copyright © 2015年 zjhaha. All rights reserved.
//

#import "ZJBaseViewController.h"

@interface ZJRouteDetailViewController : ZJBaseViewController

/**
 *  路线信息
 */
@property (nonatomic,strong)NSArray *routeDetailArr;
/**
 *   终点信息
 */
@property (nonatomic,copy)NSString *destinationAddress;
/**
 *  导航信息
 */
@property (nonatomic, strong) AMapNaviManager *naviManager;
@end
