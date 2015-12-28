//
//  HUDHelper.h
//  XIBConstraintTest
//
//  Created by zhangjiang on 15/11/5.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^AnimationSuccessBlock)(BOOL isFinish);

typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_2G= 1,
    NETWORK_TYPE_3G= 2,
    NETWORK_TYPE_4G= 3,
    NETWORK_TYPE_5G= 4,//  5G目前为猜测结果
    NETWORK_TYPE_WIFI= 5,
    
}NETWORK_TYPE;

#pragma mark - 两种枚举类型
typedef NS_ENUM(NSInteger,NETWORK_STATE) {
    NETWORK_STATE_NONE = 0,
    NETWORK_STATE_2G   = 1,
    NETWORK_STATE_3G   = 2,
    NETWORK_STATE_4G   = 3,
    NETWORK_STATE_5G   = 4,
    NETWORK_STATE_WIFI = 5,
};

@interface HUDHelper : NSObject<POPAnimationDelegate>
@property (nonatomic, strong) MBProgressHUD *HUD;//加载提示器

@property (nonatomic, strong) UIView *backView;


/**
 *  定义一个单例
 */
+ (HUDHelper *) getInstance;

/**
 *  提示 成功tip
 */
- (void)showSuccessTipWithLabel:(NSString*)label font:(CGFloat)fontSize view:(UIView*)view;

/**
 *  提示 错误tip
 */
- (void)showErrorTipWithLabel:(NSString*)label font:(CGFloat)fontSize view:(UIView*)view;

/**
 *  提示 提示信息
 */
- (void) showLabelHUD:(NSString *)label font:(CGFloat)fontSize view:(UIView*)view;

/**
 *  隐藏HUD
 */
- (void) hideHUD;


/**
 *  主屏幕上显示HUD
 */
- (void) showLabelHUDOnScreen;


/**
 *  主屏幕上显示HUD,没有图片
 */
- (void)showInformationWithoutImage:(NSString*)label font:(CGFloat)fontSize duration:(CGFloat)time view:(UIView*)view;

/**
 *  获得当前的网络状态
 */
+(NETWORK_TYPE)getNetworkTypeFromStatusBar;//获得当前的网络状态


/**
 *  判断手机号是否正确
 */
+(BOOL)CheckPhoneNumInput:(NSString *)text;


/**
 *  计算字符串中字符个数 一个汉字占据两个字符
 */
+ (NSUInteger)lenghtWithString:(NSString *)string chineseCharCount:(NSUInteger*)chineseCharCount;


/**
 *  计算并绘制字符串文本的高度
 *  @param x     最大的宽度
 */
+(CGSize)getSuitSizeWithString:(NSString *)text fontSize:(float)fontSize bold:(BOOL)bold sizeOfX:(float)x;


/**
 * 返回两个日期之间的天数
 */
+(NSInteger)calculateDaysWithDate:(NSString*)dateString;


/**
 *  比较两个日期的大小
 */
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;


/**
 *  计算两个日期之间的分钟数
 */
+(NSInteger)calculateMinuteFrom:(NSString*)dateStr1 toDate:(NSString *)dateStr2;


/**
 * date与string的相互转换
 *  @"yyyy-MM-dd HH:mm:ss"
 */
+(NSDate*) convertDateFromString:(NSString*)uiDate format:(NSString*)format;


/**
 *  字符串转日期
 *  @param dateString 输入的日期字符串形如：@"1992-05-21 13:08:08"
 */
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString*)format;


/*!
 *  判断字符串是否为空，为空返回YES
 */
+ (BOOL)isBlankString:(NSString *)string;


/**
 *  截取字符；
 */
+(NSString *)timeString:(NSString *)timeStr range:(NSUInteger)range;


/**
 *  将数组中重复的对象去除，只保留一个
 */
+ (NSArray *)arrayWithMemberIsOnly:(NSArray *)array;


/**
 *  通过颜色值生成图片
 */
+ (UIImage *)buttonImageFromColor:(UIColor *)color size:(CGSize)size;


/**
 *  获取当前系统时间 @"yyyy-MM-dd HH:mm:ss"
 */
+(NSString*)getCurrentDateWithFormat:(NSString*)format;


/**
 * 裁剪图片
 */
+ (UIImage *)clipsToRect:(CGRect)rect image:(UIImage*)orangeImage;


/**
 *  图片压缩处理
 */
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;


/**
 *  控件放大缩小动画
 */
+(void)makeScale:(UIView*)scaleView delegate:(id)delegate scale:(CGFloat)scale duration:(CFTimeInterval)duration;


/**
 *  控件旋转
 */
+(void)rotationView:(UIView*)view delegate:(id)delegate;


/**
 *  添加控件来回动画
 */
+(void)floatAnimator:(UIView *)animator;
/**
 *  截取当前屏幕
 */
+ (UIImage *) captureScreen;


/**
 *  app版本号
 */
+ (NSString *)appVersion;


/**
 *  根据颜色值生成一个渐变的颜色块
 */
+ (UIImage*) BgImageFromColors:(NSArray*)colors withFrame: (CGRect)frame;


/**
 *  百度转火星坐标
 */
+ (CLLocation*)transformFromBaiDuToGoogle:(CLLocation*)baidu;


/**
 *  火星转百度坐标
 */
+ (CLLocation*)transformFromGoogleToBaiDu:(CLLocation*)google;


#pragma mark   ==============产生随机订单号==============
/**
 *  产生随机订单号
 */
+ (NSString *)generateTradeNO;


/**
 *  改变label上的数字的变化
 *
 *  @param label  添加的label
 *  @param suffix 文字前缀或者后缀
 *  @param from   开始的值
 *  @param to     结束值
 *  @param time   持续时间
 */
+(void)makeNumChangeWithView:(UILabel*)label string:(NSString*)suffix FromValue:(CGFloat)from toValue:(CGFloat)to time:(CGFloat)time;


/*!
 @brief 简单绘制线性渐变效果 从上至下
 @param topColor 上色
 @param buttomColor 下色
 @param startpoint 起点
 @param endpoint   终点
 */
+(CALayer*)drawLineGradient:(UIColor*)topColor
                buttomColor:(UIColor*)buttomColor
                 startpoint:(CGPoint)startPoint
                   endpoint:(CGPoint)endPoint
                      frame:(CGRect)frame;



/**
 *  视图弹出动画,针对的只是view的frame中的y值变化
 *  可以自定义视图从上还是从下弹出
 *  @param view 添加的视图
 *  @param from 开始的y值
 *  @param to   结束的y值
 */
+(void)popAnimationFlyInWithView:(UIView*)popView from:(CGFloat)from to:(CGFloat)to finish:(AnimationSuccessBlock)animationBlock;


/**
 *  视图弹出动画,针对的只是view的frame中的y值变化
 *  可以自定义视图从上还是从下消失
 *  @param view 添加的视图
 *  @param from 开始的y值
 *  @param to   结束的y值
 */
+(void)popAnimationFlyOutWithView:(UIView*)popView from:(CGFloat)from to:(CGFloat)to finish:(AnimationSuccessBlock)animationBlock;
@end
