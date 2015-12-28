//
//  ZJSetttingAreaViewController.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/11.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJSetttingAreaViewController.h"
#import "WCSafeAreaView.h"
#import "ZJSafeNameView.h"
#import "CXCardView.h"
#import "ZJAreaListViewController.h"
#define KBottomViewH 35
#define KButtonTag1 100
#define KButtonTag2 103
#define KRemainViewH 85
@interface ZJSetttingAreaViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,WCSafeAreaViewDelegate>
{
    BMKLocationService *localService;
    BMKMapView *myMapView;
}
@property (strong,nonatomic) WCSafeAreaView *safeAreaView;
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic,strong) UIView *remainInfoView;//提示视图
@property (nonatomic, strong) NSMutableArray *coordinatesArr;//轨迹数组

@end

@implementation ZJSetttingAreaViewController

-(WCSafeAreaView *)safeAreaView{
    if(_safeAreaView == nil) {
        _safeAreaView = [[WCSafeAreaView alloc] initWithFrame:myMapView.frame];
        _safeAreaView.userInteractionEnabled = YES;
        _safeAreaView.delegate = self;
    }
    
    return _safeAreaView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [myMapView viewWillAppear];
    myMapView.delegate = self;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [myMapView viewWillDisappear];
    myMapView.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.coordinatesArr = [NSMutableArray array];
    [self initBaiduMapAndLocationService];
    [self settingStartButtonInfo];
    if (self.safeType == KSafeAreaTypeAdd) {
         self.title = @"设置电子围栏";
        //初始化的时候显示提示信息
        UIButton *button = (UIButton*)[self.view viewWithTag:KButtonTag1];//显示提示
        [self buttonClickToChangeView:button];
    }else{
        self.title = @"修改电子围栏";
        //初始化的时候显示提示信息
        UIButton *button = (UIButton*)[self.view viewWithTag:KButtonTag1+1];//显示提示
        [self buttonClickToChangeView:button];
    }
    
}

-(void)initBaiduMapAndLocationService{
    CGFloat mapH = ScreenHeight-64-KBottomViewH;
    myMapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, mapH)];
    myMapView.mapType = BMKMapTypeStandard;
    myMapView.zoomLevel = 17;
    [myMapView setZoomEnabled:YES];
    myMapView.compassPosition = CGPointMake(50, 80);
    myMapView.showMapScaleBar = YES;
    myMapView.mapScaleBarPosition = CGPointMake(10, ScreenHeight-110);
    myMapView.showsUserLocation = YES;//显示当前设备的位置
    myMapView.userTrackingMode = BMKUserTrackingModeNone;//定位跟随模式
    [self.view addSubview:myMapView];
    
    localService = [[BMKLocationService alloc]init];
    localService.delegate = self;
    localService.distanceFilter = 100.0;//定位最小更新距离
    localService.desiredAccuracy = kCLLocationAccuracyBest;//定位精度
    [localService startUserLocationService];
    
    //添加底部按钮
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, mapH, ScreenWidth, KBottomViewH)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    CLLocation *location = userLocation.location;
    [myMapView setCenterCoordinate:location.coordinate animated:YES];
    [myMapView updateLocationData:userLocation];
    //放大地图到自身的经纬度位置。
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(location.coordinate, BMKCoordinateSpanMake(0.01f,0.01f));
    BMKCoordinateRegion adjustedRegion = [myMapView regionThatFits:viewRegion];
    [myMapView setRegion:adjustedRegion animated:YES];
    
    [localService stopUserLocationService];
}

#pragma mark -刚开始设置显示的底部按钮
-(void)settingStartButtonInfo{
    //删除所有的子视图
    for (UIView *view in self.bottomView.subviews) {
        [view removeFromSuperview];
    }
    UIView *startView = [[UIView alloc]initWithFrame:self.bottomView.bounds];
    [self.bottomView addSubview:startView];
    NSArray *titleArr = @[@"提示",@"设置"];
    NSArray *imageArr = @[@"safeArea_remain",@"safeArea_setting"];
    CGFloat buttonW = ScreenWidth/2;
    
    for (int i = 0; i<2; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*buttonW, 0, buttonW/2, KBottomViewH)];
        titleLabel.font = KDefaultFont(16);
        titleLabel.textColor = KRGBA(245, 115, 76, 1);
        titleLabel.text = titleArr[i];
        titleLabel.textAlignment = NSTextAlignmentRight;
        [startView addSubview:titleLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(buttonW/2+i*buttonW+4, 5, 20, 20)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:imageArr[i]];
        [startView addSubview:imageView];
        
        UIButton *reminderBtn = [[UIButton alloc]initWithFrame:CGRectMake(i*buttonW, 0, buttonW, KBottomViewH)];
        reminderBtn.tag = KButtonTag1+i;
        [reminderBtn addTarget:self action:@selector(buttonClickToChangeView:) forControlEvents:UIControlEventTouchUpInside];
        [startView addSubview:reminderBtn];
        
    }
    
    UILabel *lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(buttonW, 0, 1, KBottomViewH)];
    lineLabel1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [startView addSubview:lineLabel1];
    
    UILabel *lineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    lineLabel2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [startView addSubview:lineLabel2];
}

#pragma mark -设置提示的视图
-(void)settingRemaindInfoView{
    NSArray *titleArr = @[@"1.请将地图拖动到合适位置",@"2.放大地图比例可提高精确度",@"3.尽量保持所画的安全区域为规则状态,提高精度"];
    CGFloat mapH = 0;
    mapH = ScreenHeight - 64 - KBottomViewH;
    
    self.remainInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, mapH, ScreenHeight, KRemainViewH)];
    self.remainInfoView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.remainInfoView belowSubview:self.bottomView];
    //添加直线
    UILabel *lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    lineLabel1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.remainInfoView addSubview:lineLabel1];
    //添加说明文字
    CGFloat padding = 8,buttonH = 18;
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, padding*(i+1)+i*buttonH, ScreenWidth-30, buttonH)];
        label.textColor = KRGBA(245, 115, 76,1);
        label.font = KDefaultFont(13);
        label.text = titleArr[i];
        [self.remainInfoView addSubview:label];
    }
    
    //动画展示视图
    [UIView animateWithDuration:0.3 animations:^{
        self.remainInfoView.frame = CGRectMake(0, mapH-KRemainViewH, ScreenWidth, KRemainViewH);
    }];
    
}

#pragma mark -点击设置之后显示的视图
-(void)settingCenterButtonView{
    //删除所有的子视图
    for (UIView *view in self.bottomView.subviews) {
        [view removeFromSuperview];
    }
    UIView *centerView = [[UIView alloc]initWithFrame:self.bottomView.bounds];
    [self.bottomView addSubview:centerView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, KBottomViewH)];
    cancelBtn.tag = KButtonTag1 + 2;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(buttonClickToChangeView:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = KDefaultFont(16);
    [cancelBtn setTitleColor:KRGBA(245, 115, 76 ,1) forState:UIControlStateNormal];
    [centerView addSubview:cancelBtn];
}

#pragma mark -划定轨迹之后显示的视图
-(void)settingFinalButtonView{
    //删除所有的子视图
    for (UIView *view in self.bottomView.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *finalView = [[UIView alloc]initWithFrame:self.bottomView.bounds];
    [self.bottomView addSubview:finalView];
    NSArray *titleArr = @[@"取消",@"重新设置",@"确认"];
    CGFloat KbuttonW = ScreenWidth/3;
    for (int i = 0 ; i < 3 ;i++){
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KbuttonW*i, 0, KbuttonW, KBottomViewH)];
        button.tag = i + KButtonTag2;
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = KDefaultFont(16);
        [button addTarget:self action:@selector(buttonClickToChangeView:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:KRGBA(245, 115, 76 ,1) forState:UIControlStateNormal];
        [finalView addSubview:button];
    }
    
    for (int i = 0;i < 2 ;i++){
        UILabel *lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(KbuttonW*(i+1), 0, 1, KBottomViewH)];
        lineLabel1.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [finalView addSubview:lineLabel1];
    }
    
    UILabel *lineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    lineLabel2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [finalView addSubview:lineLabel2];
}

#pragma mark -点击按钮切换视图
-(void)buttonClickToChangeView:(UIButton *)sender{
    
    NSInteger buttonTag = sender.tag - KButtonTag1;
    sender.selected = !sender.selected;
    switch (buttonTag) {
        case 0://提示
        {
            if (sender.selected) {
                [self settingRemaindInfoView];
            }else{
                [self removeInfoView];
            }
            
            NSLog(@"提示信息");
        }
            break;
            
        case 1://设置
        {
            NSLog(@"设置安全区域");
            //移除提示视图
            [self removeInfoView];
            [self.view addSubview:self.safeAreaView];
            [self settingCenterButtonView];
        }
            break;
            
        case 2://取消设置安全区域
        {
            NSLog(@"取消设置安全区域");
            self.safeAreaView.image = nil;
            [self.safeAreaView removeFromSuperview];
            [self settingStartButtonInfo];
        }
            break;
            
        case 3://取消设置好的安全区域
        {
            NSLog(@"取消设置好的安全区域");
            //  移除绘制好的路线，包括地图路径
            self.safeAreaView.image = nil;
            [self.safeAreaView removeFromSuperview];
            [self.coordinatesArr removeAllObjects];
            [myMapView removeOverlays:myMapView.overlays];
            [self settingStartButtonInfo];
        }
            break;
            
        case 4://重新设置安全区域
            //移除绘制好的路线，包括地图路径
        {
            [self.coordinatesArr removeAllObjects];
            self.safeAreaView.image = nil;
            [self.coordinatesArr removeAllObjects];
            [myMapView removeOverlays:myMapView.overlays];
            [self.view addSubview:self.safeAreaView];
        }
            break;
            
        case 5://确定设置的安全区域
        {
            NSString *dataStr = @"";
            for (CLLocation *location in self.coordinatesArr) {
                
                dataStr = [dataStr stringByAppendingString:[NSString stringWithFormat:@"%f,%f;",location.coordinate.longitude,location.coordinate.latitude]];
            }
            __weak typeof(self) weakSelf = self;
            ZJSafeNameView *nameView = [[ZJSafeNameView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 120) nameAction:^(NSString *safeName, BOOL isDismiss) {
                if (isDismiss == YES) {
                    [CXCardView dismissCurrent];
                    NSLog(@"安全区域的名字----%@",safeName);
                    //开始存储数据
                    ZJAreaModel *model = [[ZJAreaModel alloc]init];
                    model.areaName = safeName;
                    model.areaTime = [HUDHelper getCurrentDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
                    model.areaData = dataStr;
                    BOOL isSuccess;
                    if (self.safeType == KSafeAreaTypeAdd) {
                        isSuccess = [ZJAreaDataManager insertAreaInfo:model];
                        if (isSuccess) {
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }
                    }else{
                        model.areaId = self.areaChangeModel.areaId;
                        isSuccess = [ZJAreaDataManager updateAreaInfo:model];
                        if (isSuccess) {
                            NSArray *tempArr = weakSelf.navigationController.viewControllers;
                            for (UIViewController *viewClass in tempArr) {
                                if ([viewClass isKindOfClass:[ZJAreaListViewController class]]) {
                                    [weakSelf.navigationController popToViewController:viewClass animated:YES];
                                }
                            }
                            
                        }
                    }
                }
            }];
            if (weakSelf.areaChangeModel.areaName) {
                nameView.areaNameStr = weakSelf.areaChangeModel.areaName;
            }
            [CXCardView showWithView:nameView draggable:YES];
            
        }
            
            break;
    }
    
}

#pragma mark -移除提示信息视图
-(void)removeInfoView{
    //动画展示视图
    CGFloat mapH = ScreenHeight - KBottomViewH;
    [UIView animateWithDuration:0.3 animations:^{
        self.remainInfoView.frame = CGRectMake(0, mapH, ScreenWidth, KRemainViewH);
    } completion:^(BOOL finished) {
        [self.remainInfoView removeFromSuperview];
    }];
}

#pragma mark -safeAreaView的代理方法
-(void)touchesBegan:(UITouch *)touch{
    NSLog(@"开始触摸");
    CGPoint location = [touch locationInView:myMapView];
    CLLocationCoordinate2D coordinate = [myMapView convertPoint:location toCoordinateFromView:myMapView];
    CLLocation *pointLocation = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.coordinatesArr addObject:pointLocation];
}

- (void)touchesMoved:(UITouch*)touch
{
    CGPoint location = [touch locationInView:myMapView];
    CLLocationCoordinate2D coordinate = [myMapView convertPoint:location toCoordinateFromView:myMapView];
    CLLocation *pointLocation = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.coordinatesArr addObject:pointLocation];
}

- (void)touchesEnded:(UITouch*)touch
{
    [self settingFinalButtonView];
    CGPoint location = [touch locationInView:myMapView];
    CLLocationCoordinate2D coordinate = [myMapView convertPoint:location toCoordinateFromView:myMapView];
    CLLocation *pointLocation = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.coordinatesArr addObject:pointLocation];
    //图片设置为空，移除视图
    self.safeAreaView.image = nil;
    [self.safeAreaView removeFromSuperview];
    [self drawSafeSArea];//绘制轨迹
}

#pragma mark -绘制安全区域
-(void)drawSafeSArea{
    NSInteger numberOfPoints = self.coordinatesArr.count;
    if (numberOfPoints > 2){
        CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(numberOfPoints * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i<numberOfPoints; i++) {
            CLLocation *model = self.coordinatesArr[i];
            coordinateArray[i].latitude = model.coordinate.latitude ;
            coordinateArray[i].longitude = model.coordinate.longitude;
        }
        
        BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coordinateArray count:numberOfPoints];
        
//        BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coordinateArray count:numberOfPoints];
        //添加分段纹理绘制折线覆盖物
        [myMapView addOverlay:polygon];
    }
    
}

#pragma mark -百度地图绘制线段的代理方法
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    BMKOverlayPathView *overlayPathView;
    if ([overlay isKindOfClass:[BMKPolygon class]]){
        overlayPathView = (BMKOverlayPathView*)[[BMKPolygonView alloc] initWithPolygon:(BMKPolygon*)overlay];
        overlayPathView.fillColor = [KRGBA(245, 115, 76 ,1) colorWithAlphaComponent:0.4];
        overlayPathView.strokeColor = [KRGBA(0, 183, 238,1) colorWithAlphaComponent:1];
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
