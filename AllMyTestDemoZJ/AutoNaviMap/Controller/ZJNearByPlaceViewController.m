//
//  ZJNearByPlaceViewController.m
//  AllMyTestDemoZJ
//
//  Created by pg on 15/12/23.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJNearByPlaceViewController.h"
#import "ZJLocationAnnotation.h"
#import "ZJCustomeSegment.h"

#import <AudioToolbox/AudioToolbox.h>
#import "iflyMSC/IFlySpeechError.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "MANaviAnnotationView.h"
@interface ZJNearByPlaceViewController ()<MAMapViewDelegate,AMapSearchDelegate,AMapNaviManagerDelegate,CLLocationManagerDelegate,AMapNaviViewControllerDelegate,IFlySpeechSynthesizerDelegate>
{
    CLLocationManager *_locationManager;
    AMapGeoPoint *locationPoint;//定位地点

    NSMutableArray *nearByPlaceArr;
    NSArray *titleArr;
    NSInteger currentIndex;

}

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *searchNearBy;
@property (nonatomic, strong) AMapNaviManager *naviManager;
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;//语音
@property (nonatomic, strong) AMapNaviViewController *naviViewController;//导航视图
@end

@implementation ZJNearByPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButtonItem];
    [self initMyMapData];
    [self initNaviViewController];
    [self initIFlySpeech];
    [self setRightButtonItem];
}


#pragma mark -直接返回上一层
-(void)setRightButtonItem{
    UIButton *right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [right setTitle:@"截屏" forState:UIControlStateNormal];
    right.titleLabel.font = KDefaultFont(15);
    right.imageView.contentMode = UIViewContentModeLeft;
    [right addTarget:self action:@selector(nearByPlace) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    
    
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark -开始截屏
-(void)nearByPlace{
    UIImage *image = [self.mapView takeSnapshotInRect:self.view.bounds];

    UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
//#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    NSString *message = @"呵呵";
//#pragma clang diagnostic pop
    if (!error) {
        [[HUDHelper getInstance]showSuccessTipWithLabel:@"成功保存到相册" font:14 view:nil];
        
    }else
    {
        [[HUDHelper getInstance]showErrorTipWithLabel:[error description] font:14 view:nil];
        
    }
    
}

-(void)initMyMapData{
    
    nearByPlaceArr = [NSMutableArray array];
    titleArr = @[@"加油站",@"酒店",@"餐厅"];
    currentIndex = 0;
    ZJCustomeSegment *segmentView = [[ZJCustomeSegment alloc]initWithFrame:CGRectMake(0, 0, 200, 25)];
    segmentView.titleArr = titleArr;
    segmentView.backImageColor = KRGBA(20, 115, 213, 1);
    segmentView.defaultTitleColor = [UIColor whiteColor];
    segmentView.backImageColor = [UIColor whiteColor];
    segmentView.heightColor = KRGBA(20, 115, 213, 1);
    __weak typeof(self) weakSelf = self;
    [segmentView setButtonOnClickBlock:^(NSString *titleName, NSInteger selectIndex) {
        currentIndex = selectIndex;
        [weakSelf createNearByRequestDataWithKeyWord:titleName];
    }];
    self.navigationItem.titleView = segmentView;
    
    _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.zoomLevel = 14;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
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
    _searchNearBy = [[AMapSearchAPI alloc] init];
    _searchNearBy.delegate = self;
    
    //定位我的位置
    UIButton *locationBtn = [[UIButton alloc]init];
    [locationBtn setBackgroundImage:[UIImage imageNamed:@"myLocation"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationMyLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    
    [locationBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(@(-20));
        make.bottom.mas_equalTo(self.view).offset(@(-20));
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
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

#pragma mark -请求我的位置
-(void)locationMyLocation{
    [_locationManager startUpdatingLocation];
}


#pragma mark -自带的地图定位代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate = location.coordinate;//位置坐标

    locationPoint = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    //设置地图中心点
    [_mapView setCenterCoordinate:coordinate animated:YES];

    //开始请求周边数据
    [[HUDHelper getInstance]showLabelHUDOnScreen];

    //改变关键字
    [self createNearByRequestDataWithKeyWord:titleArr[currentIndex]];
    
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
}


-(void)createNearByRequestDataWithKeyWord:(NSString*)keyword{
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = locationPoint;
    request.keywords = keyword;
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"餐饮服务|生活服务|购物服务";
    request.sortrule = 0;
    request.requireExtension = YES;

    //发起周边搜索
    [_searchNearBy AMapPOIAroundSearch: request];
}

#pragma mark -POI搜索代理方法
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{

    [[HUDHelper getInstance]hideHUD];
    if(response.pois.count == 0)
    {
        [MBProgressHUD show:@"该关键字暂无对应数据😭" icon:nil view:self.navigationController.view];
        return;
    }
    
    [_mapView removeAnnotations:[_mapView annotations]];
    if (nearByPlaceArr.count) {
        [nearByPlaceArr removeAllObjects];
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
    for (AMapPOI *resultPOI in response.pois) {
        //开始添加锚点
        ZJLocationAnnotation *annotation = [[ZJLocationAnnotation alloc]init];
        annotation.coordinate =  CLLocationCoordinate2DMake(resultPOI.location.latitude, resultPOI.location.longitude);
        annotation.title = resultPOI.name;
        annotation.subtitle = resultPOI.address;
        [nearByPlaceArr addObject:annotation];
    }
    [_mapView addAnnotations:nearByPlaceArr];
    [_mapView showAnnotations:nearByPlaceArr animated:YES];
}

#pragma mark -点击callout的处罚函数
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[ZJLocationAnnotation class]])
    {
        ZJLocationAnnotation *annotation = (ZJLocationAnnotation *)view.annotation;
        
        AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        //开始导航
        //    [_naviManager calculateDriveRouteWithStartPoints:@[locationPoint] endPoints:@[endPoint] wayPoints:nil drivingStrategy:0];
        [_naviManager calculateDriveRouteWithEndPoints:@[endPoint] wayPoints:nil drivingStrategy:0];
    }
    NSLog(@"头上被点击了");
}


-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[ZJLocationAnnotation class]])
    {
        static NSString *annotationIdentifier = @"annotationIdentifier";
        MANaviAnnotationView *pointAnnotationView = (MANaviAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil)
        {
            pointAnnotationView = [[MANaviAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        }
        pointAnnotationView.canShowCallout = YES;
        pointAnnotationView.animatesDrop = YES;
        pointAnnotationView.pinColor = MAPinAnnotationColorRed;
        NSString *imageName;
        switch (currentIndex) {
            case 0://加油站
            {
                imageName = @"Navi_GasStation";
            }
                break;
                
            case 1://酒店
            {
                imageName = @"Navi_Hotel";
            }
                break;
            case 2://餐厅
            {
                imageName = @"Navi_Restaurant";
            }
                break;
        }
        pointAnnotationView.image = [UIImage imageNamed:imageName];
        return pointAnnotationView;
    }
    return nil;
}

#pragma mark -路线计算成功之后开始导航
- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
//    AMapNaviRoute *navRoute = [[naviManager naviRoute] copy];
    if (self.naviViewController == nil)
    {
        [self initNaviViewController];
    }
    [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
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
