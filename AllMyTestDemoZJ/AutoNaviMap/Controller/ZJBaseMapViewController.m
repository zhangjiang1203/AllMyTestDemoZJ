//
//  ZJBaseMapViewController.m
//  ePark
//
//  Created by pg on 15/12/21.
//  Copyright © 2015年 zjhaha. All rights reserved.
//

#import "ZJBaseMapViewController.h"
#import "ZJLocationAnnotation.h"
#import "ZJRoutePlanViewController.h"
#import "ZJRouteSearchViewController.h"
#import "ZJNearByPlaceViewController.h"
@interface ZJBaseMapViewController ()<MAMapViewDelegate,AMapSearchDelegate,CLLocationManagerDelegate,UISearchBarDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_searchAPI;
    CLLocationManager *_locationManager;
    UIView *_backView;
    UILabel *_addressLabel;
    
    AMapGeoPoint *locationPoint;
    AMapNaviPoint *endPoint;
}

@property (strong,nonatomic)UIButton *locationBtn;
@end

@implementation ZJBaseMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定位您的位置";
    [self initMyMapAndLocation];
    [self setRightButtonItem];
}

-(void)initMyMapAndLocation{
    
    _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.zoomLevel = 14;
    [self.view addSubview:_mapView];
    //搜索
    _searchAPI = [[AMapSearchAPI alloc]init];
    _searchAPI.delegate = self;
    
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
    
    [self addAddressView];
    
    //定位我的位置
    self.locationBtn = [[UIButton alloc]init];
    [self.locationBtn setBackgroundImage:[UIImage imageNamed:@"myLocation"] forState:UIControlStateNormal];
    [self.locationBtn addTarget:self action:@selector(locationMyLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.locationBtn];
    
    [self.locationBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(@(-20));
        make.bottom.mas_equalTo(self.view).offset(@(-20));
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    //添加搜索框
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    searchView.layer.cornerRadius = 5;
    searchView.layer.masksToBounds = YES;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索停车地点";
    [searchView addSubview:searchBar];
    
    self.navigationItem.titleView = searchView;
    
    
}

#pragma mark -直接返回上一层
-(void)setRightButtonItem{
    UIButton *right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [right setImage:[UIImage imageNamed:@"Navi_Life"] forState:UIControlStateNormal];
    right.imageView.contentMode = UIViewContentModeLeft;
    [right addTarget:self action:@selector(nearByPlace) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    
    
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark -跳转到搜索界面
-(void)nearByPlace{
    ZJNearByPlaceViewController *nearByVC = [[ZJNearByPlaceViewController alloc]initWithNibName:@"ZJNearByPlaceViewController" bundle:nil];
    [self.navigationController pushViewController:nearByVC animated:YES];
}


#pragma mark -searchbar的代理方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"开始搜索");
    ZJRouteSearchViewController *searchVC = [[ZJRouteSearchViewController alloc]initWithNibName:@"ZJRouteSearchViewController" bundle:nil];
    [searchVC setSelectedBlock:^(AMapPOI *selectPOI){
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(selectPOI.location.latitude, selectPOI.location.longitude);//位置坐标
        //设置地图中心点
        [_mapView setCenterCoordinate:coordinate animated:YES];
    }];
    
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark -请求我的位置
-(void)locationMyLocation{
    [_locationManager startUpdatingLocation];
}

#pragma mark -添加我的位置显示信息
-(void)addAddressView{
    //添加一个图标
    UIImageView *locationImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"parkCar"]];
    locationImage.bounds = CGRectMake(0, 0, 20, 20);
    locationImage.center = CGPointMake(ScreenWidth/2,(ScreenHeight-32)/2);
    [self.view addSubview:locationImage];
    
    _backView = [[UIView alloc]init];
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    _backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapNav = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToNav)];
    [_backView addGestureRecognizer:tapNav];
    [self.view addSubview:_backView];
    
    //背景图
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"popupBackImage"]];
    backImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    backImageView.layer.shadowOffset = CGSizeMake(1, 1);
    backImageView.layer.shadowOpacity = 0.5;
    [_backView addSubview:backImageView];
    
    //添加地址和图片
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.textColor = KRGBA(76, 76, 105, 1);
    _addressLabel.numberOfLines = 0;
    _addressLabel.font = KDefaultFont(15);
    [_backView addSubview:_addressLabel];
    
    UIImageView *navImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"parkCar"]];
    navImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_backView addSubview:navImageView];
    
    CGFloat padding = 5.0;
    [_backView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(locationImage.top).offset(-padding);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@(ScreenWidth-40));
        
    }];
    
    [backImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 10));
    }];
    
    [navImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_backView.right).offset(-padding);
        make.top.and.bottom.mas_equalTo(_backView);
        make.width.mas_equalTo(@30);
    }];
    
    [_addressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_backView.left).offset(padding);
        make.top.mas_equalTo(_backView.top).offset(padding);
        make.bottom.mas_equalTo(_backView.bottom).offset(-padding);
        make.right.mas_equalTo(navImageView.left).offset(-padding);
    }];

}


#pragma mark -进入路径规划界面
-(void)tapToNav{
    if (!endPoint) {
        [MBProgressHUD show:@"您还没有选择要停车的地方😭" icon:nil view:nil];
        return;
    }
    ZJRoutePlanViewController *routePlan = [[ZJRoutePlanViewController alloc]init];
    routePlan.endPoint = endPoint;
    routePlan.addressString = _addressLabel.text;
    [self.navigationController pushViewController:routePlan animated:YES];
}

#pragma mark -自带的地图定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate = location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //设置地图中心点
    [_mapView setCenterCoordinate:coordinate animated:YES];
    //发起逆地理编码
    locationPoint = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = locationPoint;
    regeo.requireExtension = YES;
    [_searchAPI AMapReGoecodeSearch:regeo];
    
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
}

#pragma mark -反地理编码代理方法
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        endPoint = [AMapNaviPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        
//        [_mapView removeAnnotations:[_mapView annotations]];

        NSString *addressStr = [NSString stringWithFormat:@"我要停%@附近",response.regeocode.formattedAddress];
        CGSize StrSize = [HUDHelper getSuitSizeWithString:addressStr fontSize:15 bold:NO sizeOfX:ScreenWidth-70];
        [_backView updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(StrSize.width+30);
            make.height.mas_equalTo(StrSize.height+20);
            
        }];
        _addressLabel.text = addressStr;
    }
}

#pragma mark -显示annotation
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(ZJLocationAnnotation*)annotation
{
    if ([annotation isKindOfClass:[ZJLocationAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;//设置气泡可以弹出，默认为NO
        annotationView.annotation = annotation;
        annotationView.image = [UIImage imageNamed:annotation.icon];
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    NSLog(@"当前的位置---%f----%f",_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude);
    
    //发起逆地理编码
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
    regeo.requireExtension = YES;
    [_searchAPI AMapReGoecodeSearch:regeo];
}


@end
