//
//  ZJSafeAreaDetailViewController.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/26.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJSafeAreaDetailViewController.h"
#import "ZJSetttingAreaViewController.h"
#import "WCSafeInfoView.h"
#import "AppDelegate.h"
@interface ZJSafeAreaDetailViewController ()<BMKMapViewDelegate,WCSafeInfoViewDelegate>
@property (strong,nonatomic)BMKMapView *myMapView;

@property (strong,nonatomic)NSMutableArray *areaDataArr;
@end

@implementation ZJSafeAreaDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myMapView viewWillAppear];
    self.myMapView.delegate = self;
    [self setMyBaiDuMapCenter];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.myMapView viewWillDisappear];
    self.myMapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMyBaiDuMapData];
    [self setRightButtonItem];
}

#pragma mark -添加孩子
-(void)setRightButtonItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setImage:[UIImage imageNamed:@"more_and_more"] forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeLeft;
    [button addTarget:self action:@selector(scanViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:button];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
     *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -7;
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, right];
}

-(void)scanViewController{
    //TODO:判断条件还是要修改的
    AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //添加一个View
    WCSafeInfoView *safeView = [[WCSafeInfoView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    safeView.delegate = self;
    [del.window addSubview:safeView];
    //添加一个底部视图
    [UIView animateWithDuration:0.3 animations:^{
        safeView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }];
}

#pragma mark -WCSafeInfoView的代理方法
-(void)selectedActionIndex:(NSInteger)selectedIndex{
    //0,删除 1,重新设置  2，修改提醒方式
    switch (selectedIndex) {
        case 0:
        {
            NSLog(@"开始删除");
            BOOL isSuccess =  [ZJAreaDataManager deleteAreaInfo:self.areaModel];
            if (isSuccess) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 1:
        {
            ZJSetttingAreaViewController *VC = [[ZJSetttingAreaViewController alloc]initWithNibName:@"ZJSetttingAreaViewController" bundle:nil];
            VC.safeType = KSafeAreaTypeChange;
            VC.areaChangeModel = self.areaModel;
            
            [self.navigationController pushViewController:VC animated:YES];
            NSLog(@"开始修改");
        }
            break;
    }
}


-(void)initMyBaiDuMapData{
    self.areaDataArr = [NSMutableArray array];
    self.title = self.areaModel.areaName;
    
    CGFloat mapH = ScreenHeight - 64;
    self.myMapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, mapH)];
    [self.myMapView setZoomEnabled:YES];
    [self.myMapView setZoomLevel:17];//级别，3-19
    self.myMapView.showMapScaleBar = YES;//比例尺
    [self.myMapView setMapScaleBarPosition:CGPointMake(10, mapH-50)];
    self.myMapView.showsUserLocation = YES;//显示当前设备的位置
    self.myMapView.userTrackingMode = BMKUserTrackingModeFollow;//定位跟随模式
    [self.view addSubview:self.myMapView];
    
    //处理传递过来的数据模型
     NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[self.areaModel.areaData componentsSeparatedByString:@";"]];
    [tempArr removeLastObject];
    for (NSString *tempStr in tempArr) {
        NSArray *womenArr = [tempStr componentsSeparatedByString:@","];
        CGFloat latitude = [womenArr[1] floatValue];
        CGFloat longitude = [womenArr[0] floatValue];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
        [self.areaDataArr addObject:location];
    }
}

#pragma mark -设置地图的中心点
-(void)setMyBaiDuMapCenter{
    
    //设置地图的中心点,去三个点设置地图显示区域中心点
    NSInteger areaPointNum = self.areaDataArr.count;
    
    CLLocation *location1 = (CLLocation *)self.areaDataArr[0];
    CLLocation *location2 = (CLLocation *)self.areaDataArr[areaPointNum/2];
    CLLocation *location3 = (CLLocation *)[self.areaDataArr lastObject];
    
    CGFloat latitude = (location1.coordinate.latitude+location2.coordinate.latitude+location3.coordinate.latitude)/3.0;
    CGFloat longitude = (location1.coordinate.longitude+location2.coordinate.longitude+location3.coordinate.longitude)/3.0;
    CLLocation *centerLocation = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    //设置地图的中心点和范围
    [self.myMapView setCenterCoordinate:centerLocation.coordinate animated:YES];
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = centerLocation.coordinate;//中心点
    region.span.latitudeDelta = 0.015;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.015;//纬度范围
    [self.myMapView setRegion:region animated:YES];
    
    [self drawSafeSArea];
    
}

#pragma mark -绘制安全区域
-(void)drawSafeSArea{
    NSInteger numberOfPoints = self.areaDataArr.count;
    if (numberOfPoints > 2){
        CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(numberOfPoints * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i<numberOfPoints; i++) {
            CLLocation *model = self.areaDataArr[i];
            coordinateArray[i].latitude = model.coordinate.latitude ;
            coordinateArray[i].longitude = model.coordinate.longitude;
        }
        
        BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coordinateArray count:numberOfPoints];
        //添加分段纹理绘制折线覆盖物
        [self.myMapView addOverlay:polygon];
    }
    
}
#pragma mark -百度地图绘制线段的代理方法
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    BMKOverlayPathView *overlayPathView;
    if ([overlay isKindOfClass:[BMKPolygon class]]){
        overlayPathView = (BMKOverlayPathView*)[[BMKPolygonView alloc] initWithPolygon:(BMKPolygon*)overlay];
        overlayPathView.fillColor = [KRGBA(245, 115, 76, 1) colorWithAlphaComponent:0.4];
        overlayPathView.strokeColor = [KRGBA(0, 183, 238, 1) colorWithAlphaComponent:1];
        overlayPathView.lineWidth = 3;
        return overlayPathView;
    }
    else if ([overlay isKindOfClass:[BMKPolyline class]]){
        overlayPathView = (BMKOverlayPathView*)[[BMKPolylineView alloc] initWithPolyline:(BMKPolyline *)overlay];
        overlayPathView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        overlayPathView.lineWidth = 3;
        return overlayPathView;
    }
    return nil;
}
@end
