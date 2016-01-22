//
//  ZJChartViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/22.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJChartViewController.h"
#import "ZJAnimationChooseView.h"
#import "CXCardView.h"
#define ARC4RANDOM_MAX 0x100000000
@interface ZJChartViewController ()<PNChartDelegate>

@property (nonatomic) PNLineChart    *lineChart;
@property (nonatomic) PNBarChart     *barChart;
@property (nonatomic) PNCircleChart  *circleChart;
@property (nonatomic) PNPieChart     *pieChart;
@property (nonatomic) PNScatterChart *scatterChart;
@property (nonatomic) PNRadarChart   *radarChart;

@end

@implementation ZJChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightButtonItem];
    [self changeChartType:0];
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
    NSArray *charts = @[@"Line Chart",@"Bar Chart",@"Circle Chart",@"Pie Chart",@"Radar Chart",@"Scatter Chart"];
    __weak typeof(self) weakSelf = self;
    ZJAnimationChooseView *zjView = [[ZJAnimationChooseView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 290) info:@"请选择图表样式" titles:charts nameAction:^(NSInteger animationType) {
        for (UIView *view in weakSelf.view.subviews) {
            [view removeFromSuperview];
        }
        [weakSelf changeChartType:animationType];
        [CXCardView dismissCurrent];
        
    }];
    
    [CXCardView showWithView:zjView draggable:YES];
    
}

-(void)changeChartType:(NSInteger)type{
    switch (type) {
        case 0:
            [self addLineChartView];
            break;
            
        case 1:
            [self addBarChartView];
            break;
            
        case 2:
            [self addCircleChartView];
            break;
        case 3:
            [self addPieChartView];
            break;
        case 4:
            [self addRadarChartView];
            break;
        case 5:
            [self addScatterChartView];
            break;
            
    }
}

#pragma mark -线性图表
-(void)addLineChartView{
    self.lineChart = [[PNLineChart alloc]initWithFrame:CGRectMake(0, 60, ScreenWidth, 200.0)];
    [self.lineChart setXLabels:@[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月"]];
    self.lineChart.delegate = self;
    NSArray *dataArr1 = @[@60.1,@160.0,@120.0,@110.0,@90.0,@100.0];
    PNLineChartData *data1 = [PNLineChartData new];
    data1.color = PNFreshGreen;
    data1.itemCount = self.lineChart.xLabels.count;
    data1.getData = ^(NSUInteger index){
        CGFloat yValue = [dataArr1[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data1];
    [self.lineChart strokeChart];
    [self.view addSubview:self.lineChart];
     
}

#pragma mark -柱状图
-(void)addBarChartView{

    static NSNumberFormatter *barChartFormatter;
    if (!barChartFormatter){
        barChartFormatter = [[NSNumberFormatter alloc] init];
        barChartFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        barChartFormatter.allowsFloats = NO;
        barChartFormatter.maximumFractionDigits = 0;
    }
    
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
//  self.barChart.showLabel = NO;
    self.barChart.backgroundColor = [UIColor clearColor];
    self.barChart.yLabelFormatter = ^(CGFloat yValue){
        return [barChartFormatter stringFromNumber:@(yValue)];
    };
    
    self.barChart.yChartLabelWidth = 20.0;
    self.barChart.chartMarginLeft = 30.0;
    self.barChart.chartMarginRight = 10.0;
    self.barChart.chartMarginTop = 5.0;
    self.barChart.chartMarginBottom = 10.0;
    
    
    self.barChart.labelMarginTop = 5.0;
    self.barChart.showChartBorder = YES;
    [self.barChart setXLabels:@[@"2",@"3",@"4",@"5",@"2",@"3",@"4",@"5"]];
//    self.barChart.yLabels = @[@-10,@0,@10];
//     [self.barChart setYValues:@[@10000.0,@30000.0,@10000.0,@100000.0,@500000.0,@1000000.0,@1150000.0,@2150000.0]];
    [self.barChart setYValues:@[@10.82,@1.88,@6.96,@33.93,@10.82,@1.88,@6.96,@33.93]];
    [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen,PNGreen,PNGreen,PNRed,PNGreen]];
    self.barChart.isGradientShow = NO;
    self.barChart.isShowNumbers = NO;
    
    [self.barChart strokeChart];
    
    self.barChart.delegate = self;
    
    [self.view addSubview:self.barChart];
}


#pragma mark -圆形图
-(void)addCircleChartView{
    
    self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0,150.0, SCREEN_WIDTH, 100.0)
                                                      total:@100
                                                    current:@60
                                                  clockwise:YES];
    
    self.circleChart.backgroundColor = [UIColor clearColor];
    
    [self.circleChart setStrokeColor:[UIColor clearColor]];
    [self.circleChart setStrokeColorGradientStart:KRGBA(20, 115, 213, 1)];
    [self.circleChart strokeChart];
    
    [self.view addSubview:self.circleChart];
}


#pragma mark -饼状图
-(void)addPieChartView{
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen],
                       [PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"WWDC"],
                       [PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"GOOG I/O"],
                       ];
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 135, 200.0, 200.0) items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = NO;
    [self.pieChart strokeChart];
    
    
    self.pieChart.legendStyle = PNLegendItemStyleStacked;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake(130, 350, legend.frame.size.width, legend.frame.size.height)];
    [self.view addSubview:legend];
    
    [self.view addSubview:self.pieChart];
}

#pragma mark -分散列表
-(void)addScatterChartView{
    self.scatterChart = [[PNScatterChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /6.0 - 30, 135, 280, 200)];
    //        self.scatterChart.yLabelFormat = @"xxx %1.1f";
    [self.scatterChart setAxisXWithMinimumValue:20 andMaxValue:100 toTicks:6];
    [self.scatterChart setAxisYWithMinimumValue:30 andMaxValue:50 toTicks:5];
    [self.scatterChart setAxisXLabel:@[@"x1", @"x2", @"x3", @"x4", @"x5", @"x6"]];
    [self.scatterChart setAxisYLabel:@[@"y1", @"y2", @"y3", @"y4", @"y5"]];
    
    NSArray * data01Array = [self randomSetOfObjects];
    PNScatterChartData *data01 = [PNScatterChartData new];
    data01.strokeColor = PNGreen;
    data01.fillColor = PNFreshGreen;
    data01.size = 2;
    data01.itemCount = [[data01Array objectAtIndex:0] count];
    data01.inflexionPointStyle = PNScatterChartPointStyleCircle;
    __block NSMutableArray *XAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:0]];
    __block NSMutableArray *YAr1 = [NSMutableArray arrayWithArray:[data01Array objectAtIndex:1]];
    
    data01.getData = ^(NSUInteger index) {
        CGFloat xValue = [[XAr1 objectAtIndex:index] floatValue];
        CGFloat yValue = [[YAr1 objectAtIndex:index] floatValue];
        return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];
    };
    
    [self.scatterChart setup];
    self.scatterChart.chartData = @[data01];
    /***
     this is for drawing line to compare
     CGPoint start = CGPointMake(20, 35);
     CGPoint end = CGPointMake(80, 45);
     [self.scatterChart drawLineFromPoint:start ToPoint:end WithLineWith:2 AndWithColor:PNBlack];
     ***/
    self.scatterChart.delegate = self;
    [self.view addSubview:self.scatterChart];
}

- (NSArray *) randomSetOfObjects{
    NSMutableArray *array = [NSMutableArray array];
    NSString *LabelFormat = @"%1.f";
    NSMutableArray *XAr = [NSMutableArray array];
    NSMutableArray *YAr = [NSMutableArray array];
    for (int i = 0; i < 25 ; i++) {
        [XAr addObject:[NSString stringWithFormat:LabelFormat,(((double)arc4random() / ARC4RANDOM_MAX) * (self.scatterChart.AxisX_maxValue - self.scatterChart.AxisX_minValue) + self.scatterChart.AxisX_minValue)]];
        [YAr addObject:[NSString stringWithFormat:LabelFormat,(((double)arc4random() / ARC4RANDOM_MAX) * (self.scatterChart.AxisY_maxValue - self.scatterChart.AxisY_minValue) + self.scatterChart.AxisY_minValue)]];
    }
    [array addObject:XAr];
    [array addObject:YAr];
    return (NSArray*) array;
}

-(void)addRadarChartView{
    NSArray *items = @[[PNRadarChartDataItem dataItemWithValue:3 description:@"Art"],
                       [PNRadarChartDataItem dataItemWithValue:2 description:@"Math"],
                       [PNRadarChartDataItem dataItemWithValue:8 description:@"Sports"],
                       [PNRadarChartDataItem dataItemWithValue:5 description:@"Literature"],
                       [PNRadarChartDataItem dataItemWithValue:4 description:@"Other"],
                       ];
    self.radarChart = [[PNRadarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 300.0) items:items valueDivider:1];
    [self.radarChart strokeChart];
    
    [self.view addSubview:self.radarChart];
}

-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}

@end
