//
//  HUDHelper.m
//  XIBConstraintTest
//
//  Created by zhangjiang on 15/11/5.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "HUDHelper.h"
#include <arpa/inet.h>
#include <ifaddrs.h>
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>/*相机*/
#define _IPHONE70_ 70000
static const double _x_pi = 3.14159265358979324 * 3000.0 / 180.0;
//static const char popAnimation;
@implementation HUDHelper
+ (HUDHelper *) getInstance
{
    static HUDHelper *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[HUDHelper alloc] init];
        }
    }
    return instance;
}



- (void) showLabelHUDOnScreen{
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    self.HUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    
    [[self appDelegate].window addSubview:self.HUD];
    
    self.HUD.delegate = (id)self;
    
    [self.HUD show:YES];
}

- (void) showLabelHUD:(NSString *)label font:(CGFloat)fontSize view:(UIView*)view{
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    
    if (view) {
        self.HUD = [[MBProgressHUD alloc] initWithView:view];
    }else{
        self.HUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    }
    [view addSubview:self.HUD];
    
    self.HUD.delegate = (id)self;
    //self.HUD.labelText = label;
    self.HUD.detailsLabelText = label;
    self.HUD.detailsLabelFont = [UIFont systemFontOfSize:fontSize];
    
    [self.HUD show:YES];
    
}

//提示 成功tip
- (void)showSuccessTipWithLabel:(NSString*)label font:(CGFloat)fontSize view:(UIView*)view{
    
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    if (view) {
        self.HUD = [[MBProgressHUD alloc] initWithView:view];
    }else{
        self.HUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    }
    
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/success.png"]];
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeCustomView;
    if (view) {
        [view addSubview:self.HUD];
    }else{
        [[self appDelegate].window addSubview:self.HUD];
    }
    self.HUD.delegate = (id)self;
    //self.HUD.labelText = label;
    self.HUD.detailsLabelText = label;
    self.HUD.detailsLabelFont = [UIFont systemFontOfSize:fontSize];
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:1.0];
}
#pragma mark - 只显示文字不显示图片
- (void)showInformationWithoutImage:(NSString*)label font:(CGFloat)fontSize duration:(CGFloat)time view:(UIView*)view{
    
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    if (view) {
        self.HUD = [[MBProgressHUD alloc] initWithView:view];
    }else{
        self.HUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    }
    self.HUD.customView.backgroundColor = KRGBA(211.0, 211.0, 211.0,1);
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeCustomView;
    if (view) {
        [view addSubview:self.HUD];
    }else{
        [[self appDelegate].window addSubview:self.HUD];
    }
    self.HUD.delegate = (id)self;
    //self.HUD.labelText = label;
    self.HUD.detailsLabelText = label;
    self.HUD.detailsLabelFont = [UIFont systemFontOfSize:fontSize];
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:time];
}

//提示 错误tip
- (void)showErrorTipWithLabel:(NSString*)label font:(CGFloat)fontSize view:(UIView*)view{
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    if (view) {
        self.HUD = [[MBProgressHUD alloc] initWithView:view];
    }else{
        self.HUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    }
    
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/error.png"]];
    
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeCustomView;
    
    if (view) {
        [view addSubview:self.HUD];
    }else{
        [[self appDelegate].window addSubview:self.HUD];
    }
    
    self.HUD.delegate = (id)self;
    //self.HUD.labelText = label;
    self.HUD.detailsLabelText = label;
    self.HUD.detailsLabelFont = [UIFont systemFontOfSize:fontSize];
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:1.5];
}

- (void) setHUDLabel:(NSString*)label{
    self.HUD.detailsLabelText = label;
}

#pragma mark MBProgressHUDDelegate methods --BOF
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}

- (void) hideHUD{
    [self.HUD hide:YES];
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


////  当前的网络类型
+(NETWORK_TYPE)getNetworkTypeFromStatusBar {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])     {
            dataNetworkItemView = subview;
            break;
        }
        
    }
    NETWORK_TYPE nettype = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    nettype = [num intValue];
    return nettype;
}

/* 判断手机号是否正确 */
+(BOOL)CheckPhoneNumInput:(NSString *)text{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return  [pred evaluateWithObject:text];
}


/**
 *  计算字符串中字符个数 一个汉字占据两个字符
 */
+ (NSUInteger)lenghtWithString:(NSString *)string chineseCharCount:(NSUInteger*)chineseCharCount
{
    NSUInteger len = string.length;
    // 汉字字符集
    NSString * pattern  = @"[\u4e00-\u9fa5]";
    NSError *error=nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if(error)
    {
        NSLog(@"出错");
    }
    
    
    // 计算中文字符的个数
    NSUInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    *chineseCharCount=numMatch;
    
    return len + numMatch;
}

//计算并绘制字符串文本的高度
+(CGSize)getSuitSizeWithString:(NSString *)text fontSize:(float)fontSize bold:(BOOL)bold sizeOfX:(float)x
{
    UIFont *font ;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    CGSize constraint = CGSizeMake(x, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    // 返回文本绘制所占据的矩形空间。
    CGSize contentSize = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return contentSize;
}


//获取ip地址
+(NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

/**
 *  摄像头是否有使用权限
 */
+(void)videoAuthorizationStatusAuthorized:(void(^)(void))authorized
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    //授权的返回
    if(authStatus == AVAuthorizationStatusAuthorized){
        if (!IOS7_OR_LATER) {
            [HUDHelper confirmMsg:MSG_VIDEO_NO continueBlock:^{
                
            }];
        }else{
            authorized();
        }
    }else{
        [HUDHelper confirmMsg:MSG_VIDEO_NO_AUTH continueBlock:^{
            if (IOS8_OR_LATER) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];

    }
}


#pragma mark------带Block的弹出框提示
/*!
 @brief 带Block的弹出框提示
 */
static const char continueBlockkey;
static const char cancelBlockkey;
+(void)confirmMsg:(NSString *)msg continueBlock:(continueBlock)continueBlock
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    objc_removeAssociatedObjects(alertView);
    alertView.delegate=self;
    objc_setAssociatedObject(alertView, &continueBlockkey, continueBlock, OBJC_ASSOCIATION_COPY);
    [alertView show];
}

+(void)confirmMsg:(NSString *)msg
            title:(NSString*)title
    continueBlock:(continueBlock)continueBlock
      cancelBlock:(continueBlock)cancelBlock
          noTitle:(NSString*)noTitle
         yesTitle:(NSString*)yesTitle
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:noTitle otherButtonTitles:yesTitle, nil];
    objc_removeAssociatedObjects(alertView);
    alertView.delegate=self;
    objc_setAssociatedObject(alertView, &continueBlockkey, continueBlock, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(alertView, &cancelBlockkey, cancelBlock, OBJC_ASSOCIATION_COPY);
    [alertView show];
}

+(void)showBlockMsg:(NSString*)msg continueBlock:(continueBlock)continueBlock
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    objc_removeAssociatedObjects(alertView);
    alertView.delegate=self;
    objc_setAssociatedObject(alertView, &cancelBlockkey, continueBlock, OBJC_ASSOCIATION_COPY);
    [alertView show];
}


+(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        continueBlock  messageString =(continueBlock)objc_getAssociatedObject(alertView, &continueBlockkey);
        if(messageString!=nil)
            messageString();
    }
    else if(buttonIndex==0)
    {
        cancelBlock  cancelString =(cancelBlock)objc_getAssociatedObject(alertView, &cancelBlockkey);
        if(cancelString!=nil)
            cancelString();
    }
}


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
+(NSDate*) convertDateFromString:(NSString*)uiDate format:(NSString*)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}
//字符串转日期 string->date
//输入的日期字符串形如：@"1992-05-21 13:08:08"
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString*)format{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

/*!
 @brief 空返回YES
 @string string
 */
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL ||[string isEqual:@""]||[string isEqual:@"<null>"])
        return YES;
    
    if ([string isKindOfClass:[NSNull class]])
        return YES;
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
        return YES;
    
    return NO;
}

//两个字符串是否是包含关系
+(BOOL)isContainsString:(NSString *)firstStr second:(NSString*)secondStr{
    
    if (IOS8_OR_LATER) {
        return [firstStr containsString:secondStr];
    }else{
        NSRange lengthRange = [firstStr rangeOfString:secondStr];
       return  lengthRange.length?YES: NO;
    }
}



//截取字符；
+(NSString *)timeString:(NSString *)timeStr range:(NSUInteger)range
{
    if (![self isBlankString:timeStr]) {
        if (timeStr.length > range) {
            return [timeStr substringToIndex:range];
        }else{
            return timeStr;
        }
    }else{
        return @"";
    }
}


//  将数组重复的对象去除，只保留一个
+ (NSArray *)arrayWithMemberIsOnly:(NSArray *)array
{
    NSMutableArray *categoryArray = [NSMutableArray array];
    for (unsigned i = 0; i < [array count]; i++) {
        
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
            [categoryArray addObject:[array objectAtIndex:i]];
            
        }
    }
    return categoryArray;
}


#pragma mark - 通过颜色值生成图片
+ (UIImage *)buttonImageFromColor:(UIColor *)color size:(CGSize)size{
    
    CGRect rect = CGRectMake(0,0,size.width,size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


#pragma mark -获取当前系统时间
+(NSString*)getCurrentDateWithFormat:(NSString*)format{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    NSString *time = [dateformatter stringFromDate:date];
    return time;
}

#pragma mark - 裁剪图片
+ (UIImage *)clipsToRect:(CGRect)rect image:(UIImage*)orangeImage{
    CGRect maxRect = CGRectMake(0, 0, orangeImage.size.width, orangeImage.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(orangeImage.CGImage,maxRect);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    CGContextTranslateCTM(ctx, 0, orangeImage.size.height);
    //    CGContextScaleCTM(ctx, 1, -1);
    CGContextDrawImage(ctx, CGRectMake(rect.origin.x, rect.origin.y, orangeImage.size.width, rect.size.height), orangeImage.CGImage);
    CGContextClipToRect(ctx, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    return image;
}

#pragma mark -图片压缩处理
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}


+(void)makeScale:(UIView*)scaleView delegate:(id)delegate scale:(CGFloat)scale duration:(CFTimeInterval)duration
{
    
    scaleView.layer.transform = CATransform3DIdentity;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D tr0 = CATransform3DMakeScale(1, 1, 1);
    CATransform3D tr1 = CATransform3DMakeScale(scale, scale, 1);
    CATransform3D tr2 = CATransform3DMakeScale(1, 1, 1);
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:tr0],
                            [NSValue valueWithCATransform3D:tr1],
                            [NSValue valueWithCATransform3D:tr2],
                            nil];
    [animation setValues:frameValues];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.delegate = delegate;
    [scaleView.layer addAnimation:animation forKey:@"ShakedAnimation"];
}

#pragma mark -角度转弧度
double radians(float degrees) {
    return ( degrees * M_PI ) / 180.0;
}


+(void)rotationView:(UIView*)view delegate:(id)delegate
{
    view.layer.transform=CATransform3DIdentity;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D tr0 = CATransform3DMakeRotation(radians(0),     0, 0,1);
    CATransform3D tr1 = CATransform3DMakeRotation(radians(90),    0, 0,1);
    CATransform3D tr2 = CATransform3DMakeRotation(radians(180.0), 0, 0,1);
    CATransform3D tr3 = CATransform3DMakeRotation(radians(270.0), 0, 0,1);
    CATransform3D tr4 = CATransform3DMakeRotation(radians(0), 0,  0,1);
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:tr0],
                            [NSValue valueWithCATransform3D:tr1],
                            [NSValue valueWithCATransform3D:tr2],
                            [NSValue valueWithCATransform3D:tr3],
                            [NSValue valueWithCATransform3D:tr4],
                            nil];
    [animation setValues:frameValues];
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.5;
    animation.repeatCount=HUGE_VALF;
    animation.delegate=delegate;
    [view.layer addAnimation:animation forKey:@"RotationAnimation"];
}


+ (UIImage *) captureScreen{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


#pragma mark------对动画的处理
+(void)floatAnimator:(UIView *)animator
{
    animator.layer.transform=CATransform3DIdentity;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D tr0 = CATransform3DMakeTranslation(0, 0, 0);
    CATransform3D tr1 = CATransform3DMakeTranslation(-15, 0, 0);
    CATransform3D tr3 = CATransform3DMakeTranslation(0, 0, 0);
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:tr0],
                            [NSValue valueWithCATransform3D:tr1],
                            [NSValue valueWithCATransform3D:tr3],
                            nil];
    [animation setValues:frameValues];
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 1.4;
    animation.repeatCount=10000;
    [animator.layer addAnimation:animation forKey:@"ShakedAnimation"];
}



//app版本号
+ (NSString *)appVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle]infoDictionary];
    return [NSString stringWithFormat:@"%@",infoDict[@"CFBundleShortVersionString"]];
}


+ (UIImage*) BgImageFromColors:(NSArray*)colors withFrame: (CGRect)frame{
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    //开始生成
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //定义颜色空间
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    //设置起点和终点
    CGPoint start,end;;
    start = CGPointMake(0.0, frame.size.height);
    end = CGPointMake(frame.size.width, 0.0);
    //绘制图形
    CGContextDrawLinearGradient(context, gradient, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    //生成图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //释放
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    
    return image;
    
}


#pragma mark -百度转火星坐标
+(CLLocation*)transformFromBaiDuToGoogle:(CLLocation*)baidu{
    
    double x = baidu.coordinate.longitude - 0.0065, y = baidu.coordinate.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * _x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * _x_pi);
    double gg_lon = z * cos(theta);
    double gg_lat = z * sin(theta);
    return [[CLLocation alloc]initWithLatitude:gg_lat longitude:gg_lon];
}

#pragma mark -火星转百度坐标
+(CLLocation*)transformFromGoogleToBaiDu:(CLLocation*)google
{
    double x = google.coordinate.longitude, y =  google.coordinate.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * _x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * _x_pi);
    
    double bd_lon=z * cos(theta) + 0.0065;
    double bd_lat = z * sin(theta) + 0.006;
    
    return [[CLLocation alloc]initWithLatitude:bd_lat longitude:bd_lon];
}

+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+(void)makeNumChangeWithView:(UILabel*)label string:(NSString*)suffix FromValue:(CGFloat)from toValue:(CGFloat)to time:(CGFloat)time{
    
    //此对象的属性不在Pop Property的标准属性中，要创建一个POPAnimationProperty
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"countdown" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            label.text = [NSString stringWithFormat:@"%d%@",(int)values[0],suffix];
        };
        prop.threshold = 0.01f;
    }];
    POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];   //秒表当然必须是线性的时间函数
    anBasic.property = prop;    //自定义属性
    anBasic.fromValue = @(from);   //从0开始
    anBasic.toValue = @(to);  //180秒
    anBasic.duration = time;    //持续3分钟
    anBasic.beginTime = CACurrentMediaTime();    //延迟1秒开始
    [label pop_addAnimation:anBasic forKey:@"countdown"];
    
}


+(CALayer*)drawLineGradient:(UIColor*)topColor
                buttomColor:(UIColor*)buttomColor
                 startpoint:(CGPoint)startPoint
                   endpoint:(CGPoint)endPoint
                      frame:(CGRect)frame
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.colors = [NSArray arrayWithObjects:
                       (id)topColor.CGColor,
                       (id)buttomColor.CGColor,nil];
    // 起始点
    gradient.startPoint = startPoint;
    
    // 结束点
    gradient.endPoint = endPoint;
    gradient.frame = frame;
    return gradient;
    
}

@end
