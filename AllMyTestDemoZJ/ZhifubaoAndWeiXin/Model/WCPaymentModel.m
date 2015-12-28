/*
  WCPaymentModel.m
  Xiaoxin

  Created by zhangjiang on 15/9/22.
  Copyright (c) 2015年 juzi. All rights reserved.

*/
#import "WCPaymentModel.h"


@implementation WCPaymentModel


-(instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getOrderPayResult:) name:KWXPayNoti object:nil];
    }
    return self;
}
#pragma mark -创建单例模式
+ (WCPaymentModel *)defaultPayInstance
{
    static WCPaymentModel *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[WCPaymentModel alloc] init];
        }
    }
    return instance;
}

-(void)paySuccessWithBlock:(RequestSuccessAndResponseStringBlock)payBlock{
    self.successBlock = payBlock;
}

- (void)zhiFubaoPayWithMoney:(NSString *)money productName:(NSString*)productName productDesc:(NSString*)productDesc {
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = KPartner;
    NSString *seller = KSeller;
    NSString *privateKey = KPrivateKey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [WCPaymentModel generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = productName; //商品标题
    order.productDescription = productDesc; //商品描述
    order.amount = money;//商品总价格
    order.notifyURL =  @"http:www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"zhangjiangTest";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //充值成功之后返回
            NSString *result =  resultDic[@"result"];
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            BOOL isSuccess = false;
            for (NSString *successStr in resultArr) {
                if ([successStr hasPrefix:@"success"]&&[successStr containsString:@"true"]) {
                    isSuccess = YES;
                }
            }
            if([resultDic[@"resultStatus"] integerValue] == 9000 && isSuccess){//支付成功
                //通知后台支付成功,通过block的方法传递参数值
                self.successBlock(@"1");
            }
        }];
    }
}



- (void)weiXinPayWithMoney:(NSString *)money productDesc:(NSString*)productDesc{
    
        //本实例只是演示签名过程， 请将该过程在商户服务器上实现
        
        //创建支付签名对象
        payRequsestHandler *req = [[payRequsestHandler alloc]init] ;
        //初始化支付签名对象
        [req init:APP_ID mch_id:MCH_ID];
        //设置密钥
        [req setKey:PARTNER_ID];
        
        //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPayWithTitle:productDesc price:money];
    
        if(dict == nil){
            //错误提示
//            NSString *debug = [req getDebugifo];
            [WCPaymentModel alert:@"提示信息" msg:@"暂时无法支付,请尝试其他支付方式"];
        }else{
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            
            [WXApi sendReq:req];
        }
}

#pragma mark -微信支付成功之后的代理方法
- (void)getOrderPayResult:(NSNotification *)notification{
    if ([notification.object isEqualToString:@"success"])
    {
        [WCPaymentModel alert:@"恭喜" msg:@"您已成功支付啦!"];
        self.successBlock(@"2");
        
    }
    else if ([notification.object isEqualToString:@"cancel"])
    {
        [WCPaymentModel alert:@"提示" msg:@"用户取消支付"];
        
    }else{
        [WCPaymentModel alert:@"提示" msg:@"支付失败"];
    }
}

#pragma mark -客户端提示信息
+ (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
    
    
}

#pragma mark   ==============产生随机订单号==============
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
#pragma mark -移除观察者
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KWXPayNoti object:nil];
}


@end
