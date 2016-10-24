//
//  WCPaymentModel.h
//  Xiaoxin
//
//  Created by zhangjiang on 15/9/22.
//  Copyright (c) 2015年 juzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//支付宝
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Order.h"
//微信
#import "payRequsestHandler.h"
#import "WXApiObject.h"
#import "WXApi.h"
//支付宝支付
#define KWXPayNoti  @""

#define KPartner    @"2088411072299364"
#define KSeller     @"1790267141@qq.com"
#define KPrivateKey @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAJ09/x+MYqfmR0LqIw0KBQcl8F1vGqtOSEp+mEdKoeTgv2bxtKIzKunLX83D6eBQcbGch6saXUrIZgSyHyZRggGzHIxDLHNaIYszbV1vrhN8hYd5SHabDLOwbHOEQOjhCIaRJBJlPShpn1wlzrpIVjlxvy73rhakzXXvpI0FknppAgMBAAECgYA6jMI5qhl2MW3pgatpiIiUv9C/ycYhcXXDn13udeDQi8tZdrjvCKR7B8p1oPSuHOYo34M4+Aky9mneZ8DnkMQabl0VViDIT2odOvELqeLBdhI66OWViKeqYkor9bMV9uSsFTa/h5UJwqYC+9pukDfZ7gxBL2oL17SgeUtxkjPuAQJBANFZt0KfETUpiiZWivQaj/0auWv6vFjnA68wESaFThcMRuDmSR1O7fng88YbEymUGdmyKRN9lNiaxEKlj1ry2kECQQDAR8q9fuQxeBDGnGmcGlg3Nth3vDWKV0E5uLG3va9vPwgZtEovWGje7LTJxFluWyBBgz+n1cr4ua8gnOU/kAYpAkBjQLSoyj9fQ/1yZa9lQb6oUeY88lgfkg7mHNTUvXijZren4qYhVg1vXZ5VevqfyM5krpnY2r4Z325S5qlLhj3BAkA5W7ExAg9UanqmpLYkaP9zyRqd7TkTgZ/ldiEdrKoOx4DFGjEfGoJ+LaJopff/oZNnt51flbkspUeGtQb2BSKxAkAhuxOkXpJc9dpugpVj0AyiFvA6dAAFK2pAifwn9hqgPt4KRrIIgWmVXaNK0MpD33l7U7cdBqM4h3m4JcS4R1FZ"
//=============================================================


//微信支付
//更改商户把相关参数后可测试
//==============================================================
#define WXAPP_ID          @"" //APPID
#define WXAPP_SECRET      @"" //appsecret
//商户号，填写商户对应参数
#define WXMCH_ID          @""
//商户API密钥，填写相应参数
#define WXPARTNER_ID      @""
//支付结果回调页面
#define WXNOTIFY_URL      @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"
//获取服务器端支付数据地址（商户自定义）
#define WXSP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

#define BASE_URL @"https://api.weixin.qq.com"

typedef void (^RequestSuccessAndResponseStringBlock)(NSString *string);
typedef enum {
    KPaymentZhiFuBao,
    KPaymentWeiXin
}KPaymentType;

@protocol WCPaymentModelDelegate <NSObject>

-(void)paySuccessWithType:(KPaymentType)paymentType;

@end


@interface WCPaymentModel : NSObject
/**
 *  使用block进行回调
 */
@property (nonatomic,assign)id<WCPaymentModelDelegate>delegate;

@property (nonatomic,copy)RequestSuccessAndResponseStringBlock successBlock;

/**
 *  单例模式
 */
+ (WCPaymentModel *)defaultPayInstance;

/**
 *  支付宝支付
 */
- (void)zhiFubaoPayWithMoney:(NSString *)money productName:(NSString*)name productDesc:(NSString*)productDesc;

/**
 *  微信支付
 */
- (void)weiXinPayWithMoney:(NSString *)money productDesc:(NSString*)productDesc;


/**
 *  支付成功时候的回调
 */
-(void)paySuccessWithBlock:(RequestSuccessAndResponseStringBlock)payBlock;

@end
