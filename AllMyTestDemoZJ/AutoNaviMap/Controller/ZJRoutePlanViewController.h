//
//  ZJRoutePlanViewController.h
//  ePark
//
//  Created by pg on 15/12/21.
//  Copyright © 2015年 zjhaha. All rights reserved.
//

#import "ZJBaseViewController.h"

@interface ZJRoutePlanViewController : ZJBaseViewController
@property (strong,nonatomic) AMapNaviPoint *endPoint;
@property (strong,nonatomic) NSString *addressString;
@end
