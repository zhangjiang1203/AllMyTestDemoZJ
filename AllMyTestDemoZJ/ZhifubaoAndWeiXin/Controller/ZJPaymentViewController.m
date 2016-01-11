//
//  ZJPaymentViewController.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/11.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJPaymentViewController.h"

@interface ZJPaymentViewController ()
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

@end
