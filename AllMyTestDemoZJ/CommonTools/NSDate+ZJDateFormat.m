//
//  NSDate+ZJDateFormat.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/15.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "NSDate+ZJDateFormat.h"

@implementation NSDate (ZJDateFormat)


#pragma mark - 计算两个日期之间的年数
+(NSInteger)calculateAgeFromDate:(NSDate *)date1 toDate:(NSDate *)date2{
    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear;
    NSDateComponents *components = [userCalendar components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSInteger years = [components year];
    return years;
}

#pragma mark -返回两个日期之间的天数
+(NSInteger)calculateDaysWithDate:(NSString*)dateString{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [dateFormatter dateFromString:dateString];
    int compareRes = [HUDHelper compareOneDay:date withAnotherDay:endDate];
    if (compareRes == 1) {
        //还没有过期
        //取出现在的时间差距
        NSCalendar *userCalendar = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |kCFCalendarUnitDay;
        NSDateComponents *components = [userCalendar components:unitFlags fromDate:date toDate:endDate options:0];
        NSInteger day = [components day];
        return day;
        
    }else if (compareRes == 0){
        //两个日期在同一天
        return 1;
    }else{
        //已经过期
        return -1;
    }
}
#pragma mark -比较两个日期的大小
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"oneDay is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

#pragma mark -计算两个日期之间的分钟数
+(NSInteger)calculateMinuteFrom:(NSString*)dateStr1 toDate:(NSString *)dateStr2{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate1= [dateFormatter dateFromString:dateStr1];
    NSDate *destDate2= [dateFormatter dateFromString:dateStr2];
    
    //    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    //    unsigned int unitFlags = NSCalendarUnitMinute;
    //    NSDateComponents *components = [userCalendar components:unitFlags fromDate:destDate1 toDate:destDate2 options:0];
    //    NSInteger hours = [components hour];
    
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time = [destDate1 timeIntervalSinceDate:destDate2];
    
    int minutes = ((int)time)/(60);
    //    int hours = ((int)time)%(3600*24)/3600;
    //    NSString *dateContent = [[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    return minutes;
}

#pragma mark - date与string的相互转换
+(NSString*)convertDateToString:(NSDate*)uiDate format:(NSString*)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSString *date=[formatter stringFromDate:uiDate];
    return date;
}
//字符串转日期 string->date
//输入的日期字符串形如：@"1992-05-21 13:08:08"
+ (NSDate *)convertStringToDate:(NSString *)dateString format:(NSString*)format{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}


+(void)getMistimingTime:(NSDate*)date everyblock:(everyTimerBlock)everyblock
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date]+28800;//因为时差问题要加8小时;
    if (interval ==1)
    {
        interval=0;
        //        afterblock();
    }
    else if (interval>1){
        NSInteger remainDay = interval / 86400;
        NSInteger remainHour = (interval - 86400 * remainDay) / 3600;
        NSInteger remainMinute = (interval - 86400 * remainDay - remainHour * 3600) / 60;
        NSInteger remainSecond = (interval - 86400 * remainDay - remainHour *3600 - remainMinute * 60);
        everyblock(remainDay,remainHour,remainMinute,remainSecond);
    }
};


/**
 *  获取传入服务器时间与结束时间之间差
*/
+(void)getMistimingTimeStr:(NSString*)dateString everyString:(everyStringBlock)everyString
{
    //时间格式化
    [self getMistimingTimeStr:dateString everyblock:^(NSInteger remainDay, NSInteger remainHour, NSInteger remainMinute, NSInteger remainSecond) {
        if (remainDay>=7) {
            everyString([NSString stringWithFormat:@"%@", [HUDHelper timeString:dateString range:11]]);
            
        }else
        {
            if (remainDay>=1) {
                everyString([NSString stringWithFormat:@"%ld天前", (long)remainDay]);
                return ;
            }else
            {
                if (remainHour>=1) {
                    everyString([NSString stringWithFormat:@"%ld小时前", (long)remainHour]);
                }else
                {
                    if (remainMinute>=1) {
                        everyString([NSString stringWithFormat:@"%ld分钟前", (long)remainMinute]);
                    }else
                    {
                        everyString([NSString stringWithFormat:@"%ld秒前", (long)remainSecond]);
                    }
                }
            }
        }
    }];
    
}

+(void)getMistimingTimeStr:(NSString*)dateString everyblock:(everyTimerBlock)everyblock
{
    NSString *date=[self timeString:dateString];
    
    [self getMistimingTime:[self convertStringToDate:date format:@"yyyy-MM-dd HH:mm:ss"] everyblock:^(NSInteger remainDay, NSInteger remainHour, NSInteger remainMinute, NSInteger remainSecond) {
        everyblock(remainDay,remainHour,remainMinute,remainSecond);
    }];
    
}


//截取字符；
+(NSString *)timeString:(NSString *)timeStr{
    if (![self isBlankString:timeStr]) {
        return [timeStr substringToIndex:[timeStr length]-2];
    }else{
        return @"";
    }
}

+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
        return YES;
    
    if ([string isKindOfClass:[NSNull class]])
        return YES;
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
        return YES;
    
    return NO;
}
@end
