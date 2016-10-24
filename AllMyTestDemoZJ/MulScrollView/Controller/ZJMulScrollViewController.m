//
//  ZJMulScrollViewController.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/16.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJMulScrollViewController.h"
#import "ELGoodBriefView.h"
#import "ZJAnimationChooseView.h"
#import "CXCardView.h"
#import "ZJNavAnimationInfoViewController.h"
#pragma mark -转场动画
#import "ZJNavBaseAnimation.h"
#import "WCFilterAnimation.h"
#import "ZJNavScaleAnimation.h"
#import "ZJCircleTransitionAnimation.h"
#import "PortalAnimation.h"
#import "FoldAnimation.h"
#import "ZJCardAnimation.h"
#import "ZJNatGeoAnimation.h"
#import "ZJNavMagicMoveAnination.h"
#import "ZJNavSliderAnimation.h"
#import "ZJCustomScaleAnimation.h"
@interface ZJMulScrollViewController ()<iCarouselDataSource,iCarouselDelegate,UINavigationControllerDelegate,WCFilterAnimationDelegate,ZJNavMagicMoveAninationDelegate,ELGoodBriefViewDelegate>
{
    BOOL isHiddenBar;//隐藏导航栏和选项卡
    BOOL isStateBar;//隐藏状态栏
    XTSegmentControl *segmentControl;
    NSArray *segmentTitleArr;
    
    //代理方法传递的值
    NSString *imageNameStr;
    CGRect cellFrame;
    
}

@property (strong,nonatomic)iCarousel *myCarousel;

//转场动画
@property (strong,nonatomic)WCFilterAnimation *filterAnimation;
@property (strong,nonatomic)ZJNavScaleAnimation *scaleAnimation;
@property (strong,nonatomic)ZJCircleTransitionAnimation *circleAnimation;
@property (strong,nonatomic)PortalAnimation *portalAnimation;
@property (strong,nonatomic)FoldAnimation *foldAnimation;
@property (strong,nonatomic)ZJCardAnimation *cardAnimation;
@property (strong,nonatomic)ZJNatGeoAnimation *natGeoAnimation;
@property (strong,nonatomic)ZJNavMagicMoveAnination *magicMoveAnimation;
@property (strong,nonatomic)ZJNavSliderAnimation *sliderAnimation;
@property (strong,nonatomic)ZJCustomScaleAnimation *customAnimation;
@end

@implementation ZJMulScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    [self initNavAnimation];
    [self addCarouselAndSegmentControl];
    [self setRightButtonItem];
}

-(void)initNavAnimation{
    self.filterAnimation             = [[WCFilterAnimation alloc]init];
    self.filterAnimation.delegate    = self;
    self.scaleAnimation              = [[ZJNavScaleAnimation alloc]init];
    self.circleAnimation             = [[ZJCircleTransitionAnimation alloc]init];
    self.portalAnimation             = [[PortalAnimation alloc]init];
    self.foldAnimation               = [[FoldAnimation alloc]init];
    self.cardAnimation               = [[ZJCardAnimation alloc]init];
    self.natGeoAnimation             = [[ZJNatGeoAnimation alloc]init];
    self.magicMoveAnimation          = [[ZJNavMagicMoveAnination alloc]init];
    self.magicMoveAnimation.delegate = self;
    self.sliderAnimation             = [[ZJNavSliderAnimation alloc]init];
    self.customAnimation             = [[ZJCustomScaleAnimation alloc]init];
    
}
#pragma mark -magicMove的代理方法
-(CGRect)snapShotClickPosition:(ZJNavMagicMoveAnination *)magicAnimation{
    return cellFrame;
}

-(UIImage *)snapShotImage:(ZJNavMagicMoveAnination *)magicAnimation{
    return [UIImage imageNamed:imageNameStr];
}

#pragma mark -代理传值进去
-(CGRect)filterButtonPosition:(WCFilterAnimation *)filterAnimation{
    return CGRectMake(0, 0, 20, 20);
}

-(void)setRightButtonItem{
    UIButton *rigthBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rigthBtn setBackgroundImage:[UIImage imageNamed:@"rightIcon"] forState:UIControlStateNormal];
    rigthBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rigthBtn addTarget:self action:@selector(areaListView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rigthBtn];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
     *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -7;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, right];
}

#pragma mark -动画改变视图
-(void)areaListView:(UIButton*)sender{
    NSArray *animations = @[@"iCarouselTypeLinear",
                            @"iCarouselTypeRotary",
                            @"iCarouselTypeInvertedRotary",
                            @"iCarouselTypeCylinder",
                            @"iCarouselTypeInvertedCylinder",
                            @"iCarouselTypeWheel",
                            @"iCarouselTypeInvertedWheel",
                            @"iCarouselTypeCoverFlow",
                            @"iCarouselTypeCoverFlow2",
                            @"iCarouselTypeTimeMachine",
                            @"iCarouselTypeInvertedTimeMachine"];
    ZJAnimationChooseView *zjView = [[ZJAnimationChooseView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 300) info:@"请选择动画类型" titles:animations nameAction:^(NSInteger animationType) {
        [CXCardView dismissCurrent];
        _myCarousel.type = animationType;
    }];

    [CXCardView showWithView:zjView draggable:YES];
    
}


#pragma mark -初始化添加控件
-(void)addCarouselAndSegmentControl{

    isStateBar = NO;
    isHiddenBar = NO;
    segmentTitleArr = @[@"美食",@"购物",@"酒店",@"亲子",@"旅游",@"休闲娱乐",@"生活服务",@"美容健身"];
    CGFloat segmentH = 40;
    _myCarousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, segmentH, ScreenWidth, ScreenHeight-segmentH)];
    _myCarousel.delegate = self;
    _myCarousel.dataSource = self;
    _myCarousel.backgroundColor = [UIColor whiteColor];
    _myCarousel.type = iCarouselTypeRotary;
    _myCarousel.decelerationRate = 0.7;
    _myCarousel.pagingEnabled = YES;
    [self.view addSubview:_myCarousel];
    
    __weak typeof(_myCarousel) weakCarousel = _myCarousel;
    segmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, segmentH) Items:segmentTitleArr selectedBlock:^(NSInteger index) {
        [weakCarousel scrollToItemAtIndex:index animated:NO];
    }];
    segmentControl.lineColor = KRGBA(245, 115, 76, 1);
    segmentControl.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [self.view addSubview:segmentControl];
    
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return segmentTitleArr.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    ELGoodBriefView *listView;
    if (listView == nil){
        listView = [[ELGoodBriefView alloc]initWithFrame:carousel.bounds];
    }
    listView.delegate = self;
    listView.goodType = index+1;
    return listView;
}
#pragma mark -加载view的代理方法
#pragma mark -隐藏导航栏和tabbar
-(void)dragToHiddenNavBar:(BOOL)isHidden{
    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
    //放在里面只会调用一次去执行，在外面会执行很多次
    if (isHidden) {
        if (isHiddenBar) {
            [self doHiddenStateBar:isHiddenBar];
            isHiddenBar = NO;
        }
    }else{
        if (!isHiddenBar) {
            [self doHiddenStateBar:isHiddenBar];
            isHiddenBar = YES;
        }
    }
}
#pragma mark -隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return isStateBar;
}
#pragma mark -调用方法隐藏
-(void)doHiddenStateBar:(BOOL)isHidden{
    
    isStateBar = isHiddenBar;
    //这句话加不加好像都一样
    //    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
}
-(void)clickCellToPush:(NSInteger)index imageName:(NSString *)imageName frame:(CGRect)cellRect{
    ZJNavAnimationInfoViewController  *VC = [[ZJNavAnimationInfoViewController alloc]init];
    imageNameStr = imageName;
    cellFrame = cellRect;
    VC.imageName = imageName;
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:VC animated:YES];
    
}

//滑动carousel
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    if (segmentControl) {
        //segmentControl的滑动
        [segmentControl moveIndexWithProgress:carousel.currentItemIndex];
    }
}

-(void)carouselDidScroll:(iCarousel *)carousel
{
    if (segmentControl) {
        
        float offset = carousel.scrollOffset;
        
        if (offset > 0) {
            
            [segmentControl moveIndexWithProgress:offset];
        }
    }
}


-(ZJNavBaseAnimation*)getCurrentIndexItemAnimation{
    NSInteger currentIndex = _myCarousel.currentItemIndex;
    switch (currentIndex) {
        case 0:
            return self.scaleAnimation;
            break;
        case 1:
            return self.filterAnimation;
            break;
        case 2:
            return self.circleAnimation;
            break;
        case 3:
            return self.portalAnimation;
            break;
        case 4:
            return self.foldAnimation;
            break;
        case 5:
            return self.cardAnimation;
            break;
        case 6:
            return self.natGeoAnimation;
            break;
        case 7:
            return self.sliderAnimation;
            break;
    }
    return nil;
}

#pragma mark -释放
-(void)dealloc{
    
    [_myCarousel removeFromSuperview];
    _myCarousel = nil;
    _myCarousel.delegate = nil;
    _myCarousel.dataSource = nil;

}


//#pragma mark -present跳转开始的协议动画
//-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
//    ZJNavBaseAnimation *animation = [self getCurrentIndexItemAnimation];
//    return animation;
//}
//#pragma mark -dismiss回来的动画
//-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
//    ZJNavBaseAnimation *animation = [self getCurrentIndexItemAnimation];
//    return animation;
//}

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    ZJNavBaseAnimation *animation = [self getCurrentIndexItemAnimation];
    
    if (operation == UINavigationControllerOperationPush) {
        animation.animationType = KNavAnimationTypePush;
        if ([fromVC class]==[self class]&&([toVC class]==[ZJMulScrollViewController class]||[toVC class]==[ZJNavAnimationInfoViewController class])) {
            return animation;
        }
        
    }else{
        animation.animationType = KNavAnimationTypePop ;
        if ([toVC class]==[self class]&&([fromVC class]==[ZJMulScrollViewController class]||[fromVC class]==[ZJNavAnimationInfoViewController class])) {
            return animation;
        }
    }
    return nil;
}

@end
