//
//  ZJRouteDetailViewController.m
//  ePark
//
//  Created by zjhaha on 15/12/22.
//  Copyright © 2015年 zjhaha. All rights reserved.
//

#import "ZJRouteDetailViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import "iflyMSC/IFlySpeechError.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
@interface ZJRouteDetailViewController ()<UITableViewDataSource,UITableViewDelegate,AMapNaviManagerDelegate,AMapSearchDelegate,AMapNaviViewControllerDelegate,IFlySpeechSynthesizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *navButton;

@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

//@property (nonatomic, strong) AMapNaviManager *naviManager;
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;//语音
@property (nonatomic, strong) AMapNaviViewController *naviViewController;//导航视图
@end

@implementation ZJRouteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"线路详情";
    [self setLeftButtonItem];
    
    [self initUIData];
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

-(void)initUIData{
    self.myTableView.tableFooterView = [[UIView alloc]init];
    
    self.navButton.layer.cornerRadius = 5;
    self.navButton.layer.masksToBounds = YES;
    
    //初始化导航控制器
    _naviManager = [[AMapNaviManager alloc] init];
    [_naviManager setDelegate:self];
    
    self.destinationLabel.text =  self.destinationAddress;
  ;
    AMapNaviGuide *startGuide = [self.routeDetailArr firstObject];
    AMapNaviGuide *endGuide = [self.routeDetailArr lastObject];
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:startGuide.coordinate.latitude longitude:startGuide.coordinate.longitude];
    AMapNaviPoint *endtPoint = [AMapNaviPoint locationWithLatitude:endGuide.coordinate.latitude longitude:endGuide.coordinate.longitude];
    //开始导航
    [_naviManager calculateDriveRouteWithStartPoints:@[startPoint] endPoints:@[endtPoint] wayPoints:nil drivingStrategy:0];
}

- (void)initNaviViewController
{
    if (self.naviViewController == nil){
        self.naviViewController = [[AMapNaviViewController alloc] initWithDelegate:self];
    }
    [self.naviViewController setDelegate:self];
}
#pragma mark -开始导航
- (IBAction)navButtonClick {

    //开始导航
    [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.routeDetailArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
        lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.contentView addSubview:lineLabel];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    AMapNaviGuide *guide = self.routeDetailArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd.%@",indexPath.row+1,guide.name];
    return cell;
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
    self.infoLabel.text = [NSString stringWithFormat:@"全程约%.2f公里   约%zd分钟",routeLength,routeTime];
    
    if (self.naviViewController == nil){
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

    self.naviManager.delegate = nil;
}

@end
