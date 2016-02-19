//
//  ZJPaymentViewController.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/11.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJPaymentViewController.h"
#import <PassKit/PassKit.h>
@interface ZJPaymentViewController ()<PKPaymentAuthorizationViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *zhiFuBaoImage;
@property (weak, nonatomic) IBOutlet UIImageView *weiXinImage;

@end

@implementation ZJPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (IBAction)zhiFuBaoPay:(UITapGestureRecognizer *)sender {
    
    [HUDHelper makeScale:self.zhiFuBaoImage delegate:nil scale:1.3 duration:0.2];
    [[WCPaymentModel defaultPayInstance]zhiFubaoPayWithMoney:@"0.01" productName:@"测试所用" productDesc:@"商品支付测试"];
    [[WCPaymentModel defaultPayInstance]paySuccessWithBlock:^(NSString *string) {
        if ([string isEqualToString:@"1"]) {
            NSLog(@"支付宝支付---");
        }
    }];
}

- (IBAction)weiXinPay:(UITapGestureRecognizer *)sender {
    
    [HUDHelper makeScale:self.weiXinImage delegate:nil scale:1.3 duration:0.2];
    [[WCPaymentModel defaultPayInstance]weiXinPayWithMoney:@"0.01" productDesc:@"测试用的"];
    [[WCPaymentModel defaultPayInstance]paySuccessWithBlock:^(NSString *string) {
        if ([string isEqualToString:@"2"]) {
            NSLog(@"微信支付---");
        }
    }];
}

- (IBAction)ApplePayTap:(UITapGestureRecognizer *)sender {
    
    if ([PKPaymentAuthorizationViewController canMakePayments]) {
        NSLog(@"支持支付");
        PKPaymentRequest *request = [[PKPaymentRequest alloc]init];
        
        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"鸡蛋" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        
        PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"水果" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        
        PKPaymentSummaryItem *widget3 = [PKPaymentSummaryItem summaryItemWithLabel:@"蔬菜" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"总额" amount:[NSDecimalNumber decimalNumberWithString:@"0.03"]];
        
        request.paymentSummaryItems = @[widget1,widget2,widget3,total];
        request.countryCode = @"CN";
        request.currencyCode = @"CHW";
        //此属性限制支付卡，可以支付 PKPaymentNetworkChinaUnionPay支持中国的卡
        request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay,PKPaymentNetworkMasterCard];
        request.merchantIdentifier = @"merchant.com.xiaoxin";
        /*
         PKMerchantCapabilityCredit NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 2,   // 支持信用卡
         PKMerchantCapabilityDebit  NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 3    // 支持借记卡
         */
        
        request.merchantCapabilities = PKMerchantCapabilityCredit;
        //添加邮箱及地址信息
        request.requiredBillingAddressFields = PKAddressFieldEmail | PKAddressFieldPostalAddress;
        PKPaymentAuthorizationViewController *paymentView = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:request];
        paymentView.delegate = self;
        
        if (!paymentView) {
            NSLog(@"出问题了");
        }
        
        [self presentViewController:paymentView animated:YES completion:nil];
    }else{
        NSLog(@"该设备不支持支付");
    }
}

#pragma mark -支付状态
-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion{
    BOOL asyncSuccessful = FALSE;
    if (asyncSuccessful) {
        CompletionBlock(PKPaymentAuthorizationStatusSuccess);
        NSLog(@"支付成功");
    }else{
        CompletionBlock(PKPaymentAuthorizationStatusFailure);
        NSLog(@"支付失败");
    }
    
}


-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
