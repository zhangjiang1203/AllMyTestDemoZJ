//
//  NSDate+ZJDateFormat.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/15.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YYYYMMdd @"yyyy-MM-dd"
#define YYYYMMddCN @"yyyy年MM月dd日"
#define YYYYMMddHHmm @"yyyy-MM-dd HH:mm"
#define YYYYMMddHHmmss @"yyyy-MM-dd HH:mm:ss"//2015-07-21 13:27:30
#define YYYYMMddHHmmCN @"yyyy年MM月dd日 HH:mm"
#define YYYYMMddHHmmssCN @"yyyy年MM月dd日 HH:mm:ss"


typedef void (^everyTimerBlock)(NSInteger remainDay, NSInteger remainHour,NSInteger remainMinute,NSInteger remainSecond);
typedef void (^everyStringBlock)(NSString *timeNewStr);

typedef void (^afterTimerBlock)();
@interface NSDate (ZJDateFormat)

/**
 * 返回两个日期之间的天数
 */
+(NSInteger)calculateDaysWithDate:(NSString*)dateString;


/**
 *  返回两个日期之间的年数
 */
+(NSInteger)calculateAgeFromDate:(NSDate *)date1 toDate:(NSDate *)date2;


/**
 *  比较两个日期的大小
 */
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;


/**
 *  计算两个日期之间的分钟数
 */
+(NSInteger)calculateMinuteFrom:(NSString*)dateStr1 toDate:(NSString *)dateStr2;


/**
 * date->string的相互转换
 *  模板 @"yyyy-MM-dd HH:mm:ss"
 */
+ (NSString*)convertDateToString:(NSDate*)uiDate format:(NSString*)format;


/**
 *  string->date的相互转换
 *  输入的日期字符串形如：@"1992-05-21 13:08:08"
 */
+ (NSDate *)convertStringToDate:(NSString *)dateString format:(NSString*)format;


/**
 *  获取传入时间与当前时间之间差
 */
+(void)getMistimingTime:(NSDate*)date everyblock:(everyTimerBlock)everyblock;


/**
 *  获取传入服务器时间与结束时间之间差
 */
+(void)getMistimingTimeStr:(NSString*)dateString everyString:(everyStringBlock)everyString;
@end
