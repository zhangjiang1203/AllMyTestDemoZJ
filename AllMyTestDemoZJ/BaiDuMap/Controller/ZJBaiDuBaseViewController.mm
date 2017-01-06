//
//  ZJBaiDuBaseViewController.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/9.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJBaiDuBaseViewController.h"
#import "MyAnnotation.h"
#import "ZJCustomPaoPaoView.h"
#import "ZJAreaListViewController.h"
@interface ZJBaiDuBaseViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate>
{
    BMKLocationService *localService;
    MyAnnotation *localAnnotation;
}
@property (weak, nonatomic) IBOutlet BMKMapView *myBaiDuMapView;

@property (weak, nonatomic) IBOutlet UIView *scaleBackView;
@property (weak, nonatomic) IBOutlet UIButton *scaleSmallBtn;

@property (weak, nonatomic) IBOutlet UIButton *scaleBigBtn;

@end

@implementation ZJBaiDuBaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myBaiDuMapView viewWillAppear];
    self.myBaiDuMapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.myBaiDuMapView viewWillDisappear];
    self.myBaiDuMapView.delegate = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMyBaiDuMapView];
    [self setRightButtonItem];
}


-(void)setRightButtonItem{
    UIButton *areaListBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
//    [back setImage:[UIImage imageNamed:@"back_press_base"] forState:UIControlStateNormal];
//    back.imageView.contentMode = UIViewContentModeLeft;
    [areaListBtn setTitle:@"安全区域" forState:UIControlStateNormal];
    areaListBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    back.titleLabel.ti
    [areaListBtn addTarget:self action:@selector(areaListView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:areaListBtn];
    
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
     *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -7;
    
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, left];
}
-(void)areaListView:(UIButton*)sender{
    ZJAreaListViewController *VC = [[ZJAreaListViewController alloc]initWithNibName:@"ZJAreaListViewController" bundle:nil];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -初始化百度地图
-(void)initMyBaiDuMapView{
    
    self.scaleBackView.layer.masksToBounds = YES;
    self.scaleBackView.layer.cornerRadius = 5;
    self.scaleBackView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.scaleBackView.layer.borderWidth = 0.5;
    self.scaleBackView.backgroundColor = KRGBA(240, 240, 240, 0.8);
    
    self.myBaiDuMapView.mapType = BMKMapTypeStandard;
    self.myBaiDuMapView.zoomLevel = 17;
    [self.myBaiDuMapView setZoomEnabled:YES];
    self.myBaiDuMapView.compassPosition = CGPointMake(50, 80);
    self.myBaiDuMapView.showMapScaleBar = YES;
    self.myBaiDuMapView.mapScaleBarPosition = CGPointMake(10, ScreenHeight-110);
    self.myBaiDuMapView.showsUserLocation = NO;//显示当前设备的位置
    self.myBaiDuMapView.userTrackingMode = BMKUserTrackingModeFollow;//定位跟随模式
    //设置地图
    localService = [[BMKLocationService alloc]init];
    localService.delegate = self;
    localService.distanceFilter = 100.0;//定位最小更新距离
    localService.desiredAccuracy = kCLLocationAccuracyBest;//定位精度
    [localService startUserLocationService];
}

#pragma mark -百度地图的定位方法
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    CLLocation *location = userLocation.location;
    
    [self.myBaiDuMapView setCenterCoordinate:location.coordinate animated:YES];
    [self.myBaiDuMapView updateLocationData:userLocation];
    //放大地图到自身的经纬度位置。
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(location.coordinate, BMKCoordinateSpanMake(0.01f,0.01f));
    BMKCoordinateRegion adjustedRegion = [self.myBaiDuMapView regionThatFits:viewRegion];
    [self.myBaiDuMapView setRegion:adjustedRegion animated:YES];
    
    //反地理编码，解析地址
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    geocoder.accessibilityValue = @"zh-hans";
    CLLocation *commonLocal = [HUDHelper transformFromBaiDuToGoogle:location];
    [geocoder reverseGeocodeLocation:commonLocal completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks lastObject];
        NSLog(@"具体地理位置信息---%@",placemark.name);
        NSString *currentTime = [HUDHelper getCurrentDateWithFormat:@"yyyy-MM-dd HH:mm"];
        CGSize addressSize = [HUDHelper getSuitSizeWithString:placemark.name fontSize:12 bold:NO sizeOfX:300];
        CGSize timeSize = [HUDHelper getSuitSizeWithString:currentTime fontSize:12 bold:NO sizeOfX:300];
        CGFloat paopaoViewW = [self commpareWith:addressSize size2:timeSize]+120;
        if(paopaoViewW >= ScreenWidth - 20){
            paopaoViewW = ScreenWidth - 20;
        }
        //添加地理标注
        localAnnotation = [[MyAnnotation alloc]init];
        localAnnotation.icon = @"phone_parent";
        localAnnotation.title = placemark.name;
        localAnnotation.paopaoViewW = paopaoViewW;
        localAnnotation.lastTime = currentTime;
        localAnnotation.coordinate = location.coordinate;
        [self.myBaiDuMapView addAnnotation:localAnnotation];
        //一开始就显示该地方的标注信息
        [self.myBaiDuMapView  selectAnnotation:localAnnotation animated:YES];
    }];

    [localService stopUserLocationService];
}

#pragma mark -百度地图添加标注
-(BMKAnnotationView*)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        MyAnnotation *phoneAnno=(MyAnnotation *)annotation;
        static NSString *annoID = @"anno";
        //设置MKPinAnnotationView可以设置大头针的颜色和气泡，MKAnnotationView只能设置大头针视图
        BMKAnnotationView *parentView = nil;
        if (parentView == nil) {
            parentView = [[BMKAnnotationView alloc]initWithAnnotation:phoneAnno reuseIdentifier:annoID];
            //设置气泡
            parentView.canShowCallout = YES;
            //设置大头针显示的数据
            parentView.annotation = phoneAnno;
            parentView.image = [UIImage imageNamed:phoneAnno.icon];
        }
        
        ZJCustomPaoPaoView *customView = [[ZJCustomPaoPaoView alloc]initWithFrame:CGRectMake(0, 0, phoneAnno.paopaoViewW, 70) onClick:^{
            //地图泡泡按钮的回调方法
            
        }];
        customView.customAnno = phoneAnno;
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:customView];
        ((BMKPinAnnotationView*)parentView).paopaoView = nil;
        ((BMKPinAnnotationView*)parentView).paopaoView = pView;
        return parentView;
    }
    return nil;
}


- (IBAction)mapViewButtonClick:(UIButton *)sender {

    //移除地图中的标注
    [self.myBaiDuMapView removeAnnotation:localAnnotation];
    [localService startUserLocationService];

}

#pragma mark - 缩小比例
- (IBAction)scaleBaiDuMapView:(UIButton *)sender {
    sender.tag==1?[self.myBaiDuMapView zoomOut]:[self.myBaiDuMapView zoomIn];
}

#pragma mark - 比较两个size的宽度的大小
-(float)commpareWith:(CGSize)size1 size2:(CGSize)size2{
    if (size1.width >= size2.width) {
        return size1.width;
    }else{
        return size2.width;
    }
}
@end
