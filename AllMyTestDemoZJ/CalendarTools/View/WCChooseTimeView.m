//
//  WCChooseTimeView.m
//  Picker
//
//  Created by pg on 15/9/3.
//  Copyright (c) 2015年 Xhp. All rights reserved.
//

#import "WCChooseTimeView.h"
#define KScreenViewW [UIScreen mainScreen].bounds.size.width
#define KScreenViewH [UIScreen mainScreen].bounds.size.height
#define KBottomViewH 240
#define KConfirmBtnH 30

@interface WCChooseTimeView ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSInteger currentIndex;//初始化的时候根据当前日期显示
    UIButton *leftButton;
    UIButton *rightButton;
}

@property (strong,nonatomic)UIPickerView *myPickerView;

@property (strong,nonatomic)NSMutableArray *dateArr;//第一列

@property (strong,nonatomic)NSArray *timeSectionArr;//选择时间

@property (nonatomic,copy)NSString *nextMonthDay;

@property (nonatomic,copy)NSString *beforeMonthDay;

@property (nonatomic,copy)NSString *currentTime;//当前时间
@end


@implementation WCChooseTimeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setChooseTimeUI];
    }
    return self;
}

-(void)setChooseTimeUI{
    
    self.dateArr = [NSMutableArray array];
    self.timeSectionArr = @[@"00:00-03:00",@"03:00-06:00",@"06:00-09:00",@"09:00-12:00",@"12:00-15:00",@"15:00-18:00",@"18:00-21:00",@"21:00-00:00"];
    //初始化数据
    self.currentTime = [self dateTimeToString:[NSDate date]];
    self.dateArr =  [NSMutableArray arrayWithArray:[self getAllMonthDay:[self.currentTime substringToIndex:10]]];
    for (NSString *tempStr in self.dateArr) {
        NSRange containRange = [tempStr rangeOfString:[self.currentTime substringToIndex:10]];
        if (containRange.length > 0) {
            currentIndex = [self.dateArr indexOfObject:tempStr];
        }
//        if ([tempStr containsString:[self.currentTime substringToIndex:10]]) {
//            
//        }
    }
    
    CGFloat padding = 5;
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenViewH-240, KScreenViewW, 240)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    //提示
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, KScreenViewW-30, 18)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:76/255.0 green:76/255.0 blue:105/255.0 alpha:1];
    titleLabel.text = @"请选择轨迹时间";
    [bottomView addSubview:titleLabel];
    
    //分割线
    UILabel *lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+padding, KScreenViewW, 1)];
    lineLabel1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bottomView addSubview:lineLabel1];
    
    //pickerview初始化
    self.myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(lineLabel1.frame)+padding, KScreenViewW-100, 160)];
    self.myPickerView.delegate = self;
    self.myPickerView.dataSource = self;
    [bottomView addSubview:self.myPickerView];
    [self.myPickerView selectRow:currentIndex inComponent:0 animated:YES];
    
    CGFloat centerBtnY = CGRectGetMidY(self.myPickerView.frame);
    //添加左右切换月份的两个按钮
#pragma mark -上一个月
    leftButton = [[UIButton alloc]init];
//    [leftButton setTitle:@"上" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"time_left_nor"] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    leftButton.center = CGPointMake(20, centerBtnY);
    leftButton.bounds = CGRectMake(0, 0, 40, 40);
    leftButton.tag = 1;
    [leftButton addTarget:self action:@selector(updateMonthForPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:leftButton];
    
#pragma mark -下一个月
    rightButton = [[UIButton alloc]init];
//    [rightButton setTitle:@"下" forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"time_right_nor"] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    rightButton.center = CGPointMake(CGRectGetMaxX(self.myPickerView.frame)+25, centerBtnY);
    rightButton.bounds = CGRectMake(0, 0, 40, 40);
    rightButton.tag = 2;
    [rightButton addTarget:self action:@selector(updateMonthForPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rightButton];
    
    //判断下个月是否可以点击
    int isClick = [self compareDate:[self.nextMonthDay substringToIndex:7] withDate:[self.currentTime substringToIndex:7] format:@"yyyy-MM"];
    if (isClick != 1) {
        rightButton.enabled = NO;
        [rightButton setImage:[UIImage imageNamed:@"time_right_not"] forState:UIControlStateNormal];
    }
    
    //添加底部的两个按钮和分割线
    //分割线
    UILabel *lineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myPickerView.frame)+padding, KScreenViewW, 1)];
    lineLabel2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bottomView addSubview:lineLabel2];
    
    CGFloat buttonY = CGRectGetMaxY(lineLabel2.frame);
    CGFloat buttonW = KScreenViewW/2;
    //添加取消，确认的两个按钮
    UIButton *concelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, buttonY, buttonW, KConfirmBtnH)];
    [concelButton setTitle:@"取消" forState:UIControlStateNormal];
    concelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [concelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    concelButton.tag = 3;
    [concelButton addTarget:self action:@selector(confirmOrConcelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:concelButton];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(buttonW, buttonY, buttonW, KConfirmBtnH)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    confirmButton.tag = 4;
    [confirmButton addTarget:self action:@selector(confirmOrConcelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmButton];
    
    //最后的分割线
    UILabel *lineLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(buttonW, buttonY, 1, KConfirmBtnH)];
    lineLabel3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bottomView addSubview:lineLabel3];
    
}

#pragma mark -切换月份
-(void)updateMonthForPickerView:(UIButton*)sender{
    if (sender.tag == 1) {//上一个月
        NSMutableArray *array=[self getAllMonthDay:self.beforeMonthDay];
        self.dateArr = [NSMutableArray arrayWithArray:array];
        int isClick = [self compareDate:[self.nextMonthDay substringToIndex:7] withDate:[self.currentTime  substringToIndex:7] format:@"yyyy-MM"];
        if (isClick == 0 || isClick == 1) {
            rightButton.enabled = YES;
            [rightButton setImage:[UIImage imageNamed:@"time_right_nor"] forState:UIControlStateNormal];
        }
    }else{//下一个月
        NSMutableArray *array=[self getAllMonthDay:self.nextMonthDay];
        self.dateArr = [NSMutableArray arrayWithArray:array];
    }
    //回滚到第一个元素所在的位置
    [self.myPickerView reloadAllComponents];
    [self.myPickerView selectRow:0 inComponent:0 animated:YES];
    //判断下个月是否可以点击
    int isClick = [self compareDate:[self.nextMonthDay substringToIndex:7] withDate:[self.currentTime  substringToIndex:7] format:@"yyyy-MM"];
    if (isClick == -1) {
        rightButton.enabled = NO;
        [rightButton setImage:[UIImage imageNamed:@"time_right_not"] forState:UIControlStateNormal];
        return;
    }
}

-(void)confirmOrConcelButtonClick:(UIButton*)sender{
    if (sender.tag == 3) {
        //取消
        [self removeFromSuperview];
    }else{
        NSInteger selectedRow1 = [self.myPickerView selectedRowInComponent:0];
        NSString *tempStr = self.dateArr[selectedRow1];
        NSString *yearStr = [tempStr substringToIndex:10];
        
        NSInteger selectedRow2 = [self.myPickerView selectedRowInComponent:1];
        NSString *timeStr = self.timeSectionArr[selectedRow2];
        NSArray *tempArr = [timeStr componentsSeparatedByString:@"-"];
        NSString *startTime = [NSString stringWithFormat:@"%@ %@",yearStr,tempArr[0]];
        NSString *endTime = [NSString stringWithFormat:@"%@ %@",yearStr,tempArr[1]];
        //确认
        if ([self.delegate respondsToSelector:@selector(chooseRouteStartTime:endTime:)]) {
            [self.delegate chooseRouteStartTime:startTime endTime:endTime];
            [self removeFromSuperview];
        }
    }
}

#pragma mark -pickerView的代理方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.dateArr.count;
            break;
        case 1:
            return self.timeSectionArr.count;
            break;
            
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    CGFloat ViewW = pickerView.frame.size.width/2;
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, ViewW, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:13];
    switch (component) {
        case 0:
        {
            myView.text = self.dateArr[row];
            
        }
            break;
        case 1:
        {
            myView.text = self.timeSectionArr[row];
        }
            break;
    }
    return myView;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //限制选择的时间
    NSInteger selectedRow1 = [self.myPickerView selectedRowInComponent:0];
    NSString *tempStr = self.dateArr[selectedRow1];
    NSString *yearStr = [tempStr substringToIndex:10];
    
    int num = [self compareDate:yearStr withDate:[self.currentTime substringToIndex:10] format:@"yyyy-MM-dd"];
    if(component == 0){
        if (num == -1) {//选择的日期比当前日期大
            //回滚到当前日期
            [self.myPickerView selectRow:currentIndex inComponent:0 animated:YES];
        }
        //选择前面的时候要把后面的重新置为最小的那个时间
        [self.myPickerView selectRow:0 inComponent:1 animated:YES];

    }else{
        //判断时间段不能超过今天的最大值
        //比较当前时间段是否包含这个时间
        if(num == 0){//和当前时间是同一天才回去比较时间段
            NSString *tempStr1 = [self.currentTime substringWithRange:NSMakeRange(11, 2)];
            NSInteger selectedRow2 = [self.myPickerView selectedRowInComponent:1];
            NSString *timeStr = self.timeSectionArr[selectedRow2];
            NSString *firstTime = [timeStr componentsSeparatedByString:@"-"][0];
            if ([tempStr1 integerValue] >= [[firstTime substringToIndex:2] integerValue]) {
                NSLog(@"这个时间可以有数据的");
            }else{
                NSLog(@"改时间还没有过哦");
                [self.myPickerView selectRow:0 inComponent:1 animated:YES];
            }
            
        }
    }

    
}
#pragma mark -获取一个月中的所有天
-(NSMutableArray *)getAllMonthDay:(NSString *)timeString
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [formate dateFromString:timeString];//将时间转换成NSDate
    NSDateComponents *currentComponents = [self getWeekDay:currentDate];
    NSInteger currentYear = currentComponents.year;//获取时间所在年
    NSInteger currentMonth = currentComponents.month;//获取时间所在月
    NSRange currentDayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit: NSCalendarUnitMonth forDate:currentDate];//时间所在月的长度(几号-几号)
    NSMutableArray *allDay = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i=1;i<currentDayRange.length+1;i++)//拼接成时间字符串
    {
        //处理日期格式
        NSString *oneDayString;
        if (currentMonth < 10) {
            if (i<10) {
                oneDayString = [NSString stringWithFormat:@"%zd-0%zd-0%d",currentYear,currentMonth,i];
            }else{
                oneDayString = [NSString stringWithFormat:@"%zd-0%zd-%d",currentYear,currentMonth,i];
            }
            
        }else{
            if (i<10) {
                oneDayString = [NSString stringWithFormat:@"%zd-%zd-0%d",currentYear,currentMonth,i];
            }else{
                oneDayString = [NSString stringWithFormat:@"%zd-%zd-%d",currentYear,currentMonth,i];
            }
        }
        
        NSString *weekDay = [self weekdayStringFromDate:[self stringTimeToDate:oneDayString]];
        NSString *timeString = [NSString stringWithFormat:@"%@ %@",oneDayString,weekDay];
        [allDay addObject:timeString];
    }
    if (currentMonth == 12)//计算下个月第一天的时间
    {
        self.nextMonthDay = [NSString stringWithFormat:@"%zd-0%d-0%d",currentYear+1,1,1];
    }
    else
    {//设置日期的格式
        if(currentMonth+1 <10){
            self.nextMonthDay = [NSString stringWithFormat:@"%zd-0%zd-0%d",currentYear,currentMonth+1,1];
        }else{
            self.nextMonthDay = [NSString stringWithFormat:@"%zd-%zd-0%d",currentYear,currentMonth+1,1];
        }
        
    }
    if (currentMonth == 1)//计算上个月第一天的时间
    {
        self.beforeMonthDay = [NSString stringWithFormat:@"%zd-%d-0%d",currentYear-1,12,1];
    }
    else
    {
        if (currentMonth-1 > 9) {
            self.beforeMonthDay = [NSString stringWithFormat:@"%zd-%zd-0%d",currentYear,currentMonth-1,1];
        }else{
            self.beforeMonthDay = [NSString stringWithFormat:@"%zd-0%zd-0%d",currentYear,currentMonth-1,1];
        }
        
    }
    return allDay;
}

#pragma mark -封装的时间方法
-(NSDateComponents *)getWeekDay:(NSDate *)date
{
    unsigned units=NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitWeekday;
    NSCalendar *mycal=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [mycal setFirstWeekday:1];
    NSDateComponents *comp =[mycal components:units fromDate:date];
    return comp;
}

#pragma mark -将日期转化为周几
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

#pragma mark -日期转字符串
-(NSDate*)stringTimeToDate:(NSString*)timeStr{
    //转换时间格式
    NSDateFormatter *df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    NSDate *date = [[NSDate alloc]init];
    date = [df dateFromString:timeStr];
    return date;
}


#pragma mark -日期转字符串
-(NSString *)dateTimeToString:(NSDate*)dateTime{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH"];
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    
    return [df stringFromDate:dateTime];
}

#pragma mark -比较两个日期的大小
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02 format:(NSString*)dateFormat{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormat];
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self]; //返回触摸点在视图中的当前坐标
    
    CGFloat limitH = [UIScreen mainScreen].bounds.size.height - KBottomViewH;
    if (point.y < limitH) {
        [self removeFromSuperview];
    }
}

@end
