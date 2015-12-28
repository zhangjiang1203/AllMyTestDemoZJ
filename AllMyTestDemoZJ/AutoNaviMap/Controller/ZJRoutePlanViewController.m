//
//  ZJRoutePlanViewController.m
//  ePark
//
//  Created by pg on 15/12/21.
//  Copyright © 2015年 zjhaha. All rights reserved.
//

#import "ZJRoutePlanViewController.h"
#import "ZJLocationAnnotation.h"
#import "ZJRouteDetailViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import "iflyMSC/IFlySpeechError.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

@interface ZJRoutePlanViewController ()<MAMapViewDelegate,AMapSearchDelegate,AMapNaviManagerDelegate,CLLocationManagerDelegate,AMapNaviViewControllerDelegate,IFlySpeechSynthesizerDelegate>{
    CLLocationManager *_locationManager;
    UILabel *addressLabel;//显示距离和时间
    NSArray *routeListArr;
}

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *searchRoute;
@property (nonatomic, strong) AMapNaviManager *naviManager;
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;//语音
@property (nonatomic, strong) AMapNaviViewController *naviViewController;//导航视图
@end

@implementation ZJRoutePlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"路径规划";
    [self setLeftButtonItem];
    [self initMyMapData];
    [self initNaviViewController];
    [self initIFlySpeech];
}

- (void)initIFlySpeech
{
    if (self.iFlySpeechSynthesizer == nil)
    {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
}

- (void)initNaviViewController
{
    if (self.naviViewController == nil)
    {
        self.naviViewController = [[AMapNaviViewController alloc] initWithDelegate:self];
    }
    
    [self.naviViewController setDelegate:self];
}

-(void)initMyMapData{
    _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.zoomLevel = 14;
    [self.view addSubview:_mapView];
    
    //初始化导航控制器
    _naviManager = [[AMapNaviManager alloc] init];
    [_naviManager setDelegate:self];
    
    //定位管理器
    _locationManager = [[CLLocationManager alloc]init];
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate = self;
        //设置定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance = 10.0;//十米定位一次
        _locationManager.distanceFilter = distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }

    //初始化检索对象
    _searchRoute = [[AMapSearchAPI alloc] init];
    _searchRoute.delegate = self;
    
    UIView *addressView = [[UIView alloc]init];
    addressView.userInteractionEnabled = YES;
    addressView.backgroundColor = KRGBA(255, 255, 255, 0.8);
    addressView.layer.cornerRadius = 5;
    addressView.layer.masksToBounds = YES;
    addressView.layer.shadowColor = [UIColor blackColor].CGColor;
    addressView.layer.shadowOffset = CGSizeMake(1, 1);
    addressView.layer.shadowOpacity = 0.5;
//    UITapGestureRecognizer *tapDetail = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAddressDetail)];
//    [addressView addGestureRecognizer:tapDetail];
    [self.view addSubview:addressView];
    
    addressLabel = [[UILabel alloc]init];
    addressLabel.textColor = KRGBA(30, 30, 30, 1);
    addressLabel.font = KDefaultFont(17);
    [addressView addSubview:addressLabel];
    
    UIButton *navBtn = [[UIButton alloc]init];
    navBtn.layer.cornerRadius = 5;
    navBtn.layer.masksToBounds = YES;
    navBtn.layer.borderColor = KRGBA(30, 30, 30, 1).CGColor;
    navBtn.layer.borderWidth = 1;
    [navBtn setTitle:@"导航" forState:UIControlStateNormal];
    navBtn.titleLabel.font = KDefaultFont(16);
    [navBtn setTitleColor:KRGBA(30, 30, 30, 1) forState:UIControlStateNormal];
    [navBtn addTarget:self action:@selector(startNav) forControlEvents:UIControlEventTouchUpInside];
    [addressView addSubview:navBtn];
    
    CGFloat padding = 15;
    [addressView makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(padding);
        make.right.mas_equalTo(self.view).offset(-padding);
        make.bottom.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(@50);
    }];
    
    [navBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(addressView.right).offset(-10);
        make.centerY.mas_equalTo(addressView);
        make.size.mas_equalTo(CGSizeMake(70, 40));
    }];

    [addressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressView.left).offset(10);
        make.right.mas_equalTo(navBtn.left).offset(-10);
        make.centerY.mas_equalTo(addressView);
        make.height.mas_equalTo(@30);
    }];
    
}
#pragma mark -开始导航
-(void)startNav{
    //开始导航
    [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
}

#pragma mark -跳转到详细路径界面
//-(void)showAddressDetail{
//    ZJRouteDetailViewController *routeDetail = [[ZJRouteDetailViewController alloc]initWithNibName:@"ZJRouteDetailViewController" bundle:nil];
//    routeDetail.routeDetailArr = routeListArr;
//    routeDetail.destinationAddress = self.addressString;
//    routeDetail.naviManager = _naviManager;
//    [self.navigationController pushViewController:routeDetail animated:YES];
//}

#pragma mark -自带的地图定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate = location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //设置地图中心点
    [_mapView setCenterCoordinate:coordinate animated:YES];
    
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    //开始导航
    [_naviManager calculateDriveRouteWithStartPoints:@[startPoint] endPoints:@[self.endPoint] wayPoints:nil drivingStrategy:0];
    
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
}

#pragma mark -显示路线
- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute routeList:(NSArray*)listArr
{
    if (naviRoute == nil)
    {
        return;
    }
    routeListArr = listArr;
    //添加标注
    [self.mapView removeAnnotations:[self.mapView annotations]];
    NSMutableArray *annotationArr = [NSMutableArray array];
    NSInteger routeArrCount = listArr.count;
    for (int i = 0; i< routeArrCount; i++) {
        AMapNaviGuide *guide = listArr[i];
        ZJLocationAnnotation *annotation = [[ZJLocationAnnotation alloc]init];
        annotation.coordinate  = CLLocationCoordinate2DMake(guide.coordinate.latitude, guide.coordinate.longitude);
        if (i == 0) {
            annotation.navPointType = LocationAnnotationTypeStart;
        }else if (i == routeArrCount - 1){
            annotation.navPointType = LocationAnnotationTypeEnd;
        }else{
            annotation.navPointType = LocationAnnotationTypeWay;
        }
        [annotationArr addObject:annotation];
    }
    [self.mapView addAnnotations:annotationArr];

    // 清除旧的overlays
    [self.mapView removeOverlays:self.mapView.overlays];
    NSUInteger coordianteCount = [naviRoute.routeCoordinates count];
    CLLocationCoordinate2D coordinates[coordianteCount];
    //添加路径线
    for (int i = 0; i < coordianteCount; i++)
    {
        AMapNaviPoint *aCoordinate = [naviRoute.routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }

    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    [self.mapView addOverlay:polyline];
}
#pragma mark -显示标注
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(ZJLocationAnnotation *)annotation{
    if ([annotation isKindOfClass:[ZJLocationAnnotation class]])
    {
        static NSString *annotationIdentifier = @"annotationIdentifier";
        MAPinAnnotationView *pointAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil)
        {
            pointAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:annotationIdentifier];
        }
        if (annotation.navPointType == LocationAnnotationTypeStart)
        {
            pointAnnotationView.image = [UIImage imageNamed:@"naviWayPointStart"];
        }else if (annotation.navPointType == LocationAnnotationTypeWay){
            pointAnnotationView.image = [UIImage imageNamed:@"naviWayPoint"];
        }else{
            pointAnnotationView.image = [UIImage imageNamed:@"naviWayPointEnd"];

        }
        return pointAnnotationView;
    }
    
    return nil;
}

#pragma mark -显示路径
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:(MAPolyline*)overlay];
        polylineView.lineWidth = 5.0f;
        polylineView.strokeColor = [UIColor blueColor];
        
        return polylineView;
    }
    return nil;
}

#pragma mark - AMapNaviManager Delegate
- (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error
{
    NSLog(@"error:{%@}",error.localizedDescription);
}

- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    NSLog(@"didPresentNaviViewController");
    //开始模拟导航
    [self.naviManager startEmulatorNavi];
}

- (void)naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController
{
    NSLog(@"didDismissNaviViewController");
}

- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    AMapNaviRoute *navRoute = [[naviManager naviRoute] copy];
       //路线的长度及所需要的时间
    CGFloat routeLength =  navRoute.routeLength/1000.0;
    int routeTime = navRoute.routeTime/60;
    NSLog(@"行车的距离%f----时间%zd",routeLength,routeTime);
    addressLabel.text = [NSString stringWithFormat:@"全程约%.2f公里   约%zd分钟",routeLength,routeTime];
    //显示路线
    [self showRouteWithNaviRoute:navRoute routeList:[naviManager getNaviGuideList]];
    if (self.naviViewController == nil)
    {
        [self initNaviViewController];
    }

}

- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error
{
    NSLog(@"onCalculateRouteFailure");
}

- (void)naviManagerNeedRecalculateRouteForYaw:(AMapNaviManager *)naviManager
{
    NSLog(@"NeedReCalculateRouteForYaw");
}

- (void)naviManager:(AMapNaviManager *)naviManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)naviManagerDidEndEmulatorNavi:(AMapNaviManager *)naviManager
{
    NSLog(@"DidEndEmulatorNavi");
}

- (void)naviManagerOnArrivedDestination:(AMapNaviManager *)naviManager
{
    NSLog(@"OnArrivedDestination");
}

- (void)naviManager:(AMapNaviManager *)naviManager onArrivedWayPoint:(int)wayPointIndex
{
    NSLog(@"onArrivedWayPoint");
}

- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviLocation:(AMapNaviLocation *)naviLocation
{
    //    NSLog(@"didUpdateNaviLocation");
}

- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviInfo:(AMapNaviInfo *)naviInfo
{
    //    NSLog(@"didUpdateNaviInfo");
}

- (BOOL)naviManagerGetSoundPlayState:(AMapNaviManager *)naviManager
{
    return 0;
}

- (void)naviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    if (soundStringType == AMapNaviSoundTypePassedReminder)
    {
        //用系统自带的声音做简单例子，播放其他提示音需要另外配置
        AudioServicesPlaySystemSound(1009);
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [_iFlySpeechSynthesizer startSpeaking:soundString];
        });
    }
}

- (void)naviManagerDidUpdateTrafficStatuses:(AMapNaviManager *)naviManager
{
    NSLog(@"DidUpdateTrafficStatuses");
}

#pragma mark - AManNaviViewController Delegate

- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [_iFlySpeechSynthesizer stopSpeaking];
    });
    
    [self.naviManager stopNavi];
    
    [self.naviManager dismissNaviViewControllerAnimated:YES];
}

- (void)naviViewControllerMoreButtonClicked:(AMapNaviViewController *)naviViewController
{
    if (self.naviViewController.viewShowMode == AMapNaviViewShowModeCarNorthDirection)
    {
        self.naviViewController.viewShowMode = AMapNaviViewShowModeMapNorthDirection;
    }
    else
    {
        self.naviViewController.viewShowMode = AMapNaviViewShowModeCarNorthDirection;
    }
}

- (void)naviViewControllerTurnIndicatorViewTapped:(AMapNaviViewController *)naviViewController
{
    [self.naviManager readNaviInfoManual];
}

#pragma mark - iFlySpeechSynthesizer Delegate

- (void)onCompleted:(IFlySpeechError *)error
{
    NSLog(@"Speak Error:{%d:%@}", error.errorCode, error.errorDesc);
}

-(void)dealloc{
    self.naviViewController.delegate = nil;
    _mapView.delegate = nil;
    self.naviManager.delegate = nil;
}

@end
