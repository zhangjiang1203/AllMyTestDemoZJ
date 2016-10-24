//
//  AppDelegate.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/6.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "AppDelegate.h"
#import "ZJBaseNavViewController.h"
#import "ZJBaseViewController.h"
#import "ZJRootViewController.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "IQKeyboardManager.h"

#import "ZJAreaDataManager.h"
#import "ZJAreaModel.h"

#import "ZJMulScrollViewController.h"
#import "ZJBaiDuBaseViewController.h"
#import "ZJPaymentViewController.h"

#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySetting.h"

#define _IPHONE70_ 70000

//高德地图导航
static const NSString *KGaoDeAPIKey = @"34d5745e9a952db4b323c762c12bb9c0";

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate
- (void)configureAPIKey
{
    //注册高德地图的appKey
    [MAMapServices sharedServices].apiKey = (NSString*)KGaoDeAPIKey;
    [AMapNaviServices sharedServices].apiKey = (NSString*)KGaoDeAPIKey;
    [AMapSearchServices sharedServices].apiKey = (NSString*)KGaoDeAPIKey;
}

- (void)configIFlySpeech
{
    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@,timeout=%@",@"5678ba3a",@"20000"]];
    
    [IFlySetting setLogFile:LVL_NONE];
    [IFlySetting showLogcat:NO];
    
    // 设置语音合成的参数
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];//合成的语速,取值范围 0~100
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];//合成的音量;取值范围 0~100
    
    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    // 音频采样率,目前支持的采样率有 16000 和 8000;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    // 当你再不需要保存音频时，请在必要的地方加上这行。
    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //手动 添加3D touch功能标签
    [self init3DTouchActionShow:YES];
    
    [self configureAPIKey];
    [self configIFlySpeech];
    
    //初始化百度地图
    self.mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"Ach1MeflrOVkuTYiHxqFaidg8SPEXykS"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    
//    for(NSString *familyName in [UIFont familyNames]){
//        NSLog(@"Font FamilyName = %@",familyName); //*输出字体族科名字
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//            NSLog(@"\t%@",fontName);         //*输出字体族科下字样名字
//        }
//    }
    
    
    [AFNClientHelper startMonitoring];
    
    //创建数据库
    [self openDBDataBase];

    //初始化微信支付
    [WXApi registerApp:WXAPP_ID withDescription:@"e校信"];
    //设置全局的键盘处理,不显示工具条
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    //初始化窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ZJRootViewController *Root = [[ZJRootViewController alloc]initWithNibName:@"ZJRootViewController" bundle:nil];
    ZJBaseNavViewController *Nav = [[ZJBaseNavViewController alloc]initWithRootViewController:Root];
    self.window.rootViewController = Nav;
    [self.window makeKeyAndVisible];
    return YES;
}


/**
 *  手动添加3D touch功能
 */
-(void)init3DTouchActionShow:(BOOL)isShow{
    
    /** type 该item 唯一标识符
     localizedTitle ：标题
     localizedSubtitle：副标题
     icon：icon图标 可以使用系统类型 也可以使用自定义的图片
     userInfo：用户信息字典 自定义参数，完成具体功能需求
     */
    UIApplication *application = [UIApplication sharedApplication];
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLove];
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc]initWithType:KCutItem1 localizedTitle:@"百度地图" localizedSubtitle:@"" icon:icon1 userInfo:nil];
    
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc]initWithType:KCutItem2 localizedTitle:@"多视图滚动" localizedSubtitle:@"" icon:icon2 userInfo:nil];
    
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
    UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc]initWithType:KCutItem3 localizedTitle:@"个人支付" localizedSubtitle:@"" icon:icon3 userInfo:nil];
    if (isShow) {
        application.shortcutItems = @[item1,item2,item3];

    }else{
        application.shortcutItems = @[];
    }
}

#pragma mark -数据库操作
-(void)openDBDataBase{
    //创建数据库及相关操作
    FMDatabase *fmdb = [ZJAreaDataManager shareDataBase];
    if (![fmdb open]) {
        NSLog(@"无法打开数据库.");
        return;
    }
    [ZJAreaDataManager createTableList];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *str=[NSString stringWithFormat:@"%@",url];
    NSString *Str=[str substringWithRange:NSMakeRange(0, 2)];
    if ([Str isEqualToString:@"wx"]) {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //取出scheme
    NSArray *schemeArr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    NSString *schemeStr;
    for (NSDictionary *tempDict in schemeArr) {
        NSArray *keyArr =  tempDict.allKeys;
        for (NSString *tempStr in keyArr) {
            if ([tempStr isEqualToString:@"CFBundleURLSchemes"]) {
                schemeStr = tempDict[@"CFBundleURLSchemes"][0];
            }
        }
    }
    NSString *str=[NSString stringWithFormat:@"%@",url];
    if ([HUDHelper isContainsString:str second:schemeStr]) {
        //传递的数据过来
        NSArray *tempArr = [str componentsSeparatedByString:@"://"];
        NSString *decodeStr = tempArr[1];
        
        [HUDHelper confirmMsg:[decodeStr URLDecodeString] continueBlock:^{
            
        }];
        
    }else{
        NSString *subStr=[str substringWithRange:NSMakeRange(0, 2)];
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }
        if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
            [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }
        if ([subStr isEqualToString:@"wx"])
        {
            BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
            NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
            return  isSuc;
        }
    }
    return YES;
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KWXPayNoti object:@"success"];
                break;
            }
            case WXErrCodeUserCancel://WXErrCodeCommon     = -1,
            {
                strMsg = @"已取消支付";
                [[NSNotificationCenter defaultCenter] postNotificationName:KWXPayNoti object:@"cancel"];
            }
                break;
            default:{
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KWXPayNoti object:@"fail"];
                break;
            }
        }
    }
}

#pragma mark -3Dtouch功能
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler{
    //判断先前我们设置的唯一标识
    UIViewController *myVC;
    if ([shortcutItem.type isEqualToString:@"muBaiDuMap"]) {
        myVC = [[ZJBaiDuBaseViewController alloc]initWithNibName:@"ZJBaiDuBaseViewController" bundle:nil];
    }else if ([shortcutItem.type isEqualToString:@"MulScroll"]){
        myVC = [[ZJMulScrollViewController alloc]initWithNibName:@"ZJMulScrollViewController" bundle:nil];
    }else if ([shortcutItem.type isEqualToString:@"ownPayment"]){
        myVC = [[ZJPaymentViewController alloc]initWithNibName:@"ZJPaymentViewController" bundle:nil];
    }
    ZJBaseNavViewController *nav = [[ZJBaseNavViewController alloc]initWithRootViewController:myVC];
    //设置当前的VC 为rootVC
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
