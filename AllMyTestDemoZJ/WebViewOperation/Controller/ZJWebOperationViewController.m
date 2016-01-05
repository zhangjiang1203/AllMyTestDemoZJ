//
//  ZJWebOperationViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/5.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJWebOperationViewController.h"
#import "IQKeyboardManager.h"
#import "ZJInputToolView.h"
#define KBottomH 40
@interface ZJWebOperationViewController ()<UIWebViewDelegate>

@property (strong,nonatomic)UIWebView *myWebView;

//添加appTOJS的交互
@property (strong,nonatomic)ZJInputToolView *inputToolBar;

@end

@implementation ZJWebOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"webView交互";
    [self initwebViewUIData];
    
}

-(void)initwebViewUIData{
    
    //取消自动键盘
    [[IQKeyboardManager sharedManager]setEnable:NO];
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    
    CGFloat webViewH = ScreenHeight - 64 - KBottomH;
    self.myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, webViewH)];
    self.myWebView.delegate = self;
    [_myWebView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle]URLForResource:@"AppJsDemo" withExtension:@"html"]]];
    [self.view addSubview:self.myWebView];
    
    self.inputToolBar = [[ZJInputToolView alloc]initWithFrame:CGRectMake(0, webViewH, ScreenWidth, KBottomH)];
//    [self.inputToolBar setMessageAction:^(NSString *message){
//        
//    }]
    [self.inputToolBar sendMessageToJavaScript:^(NSString *message) {
        NSString *messageStr = [NSString stringWithFormat:@"sendMessageToJS('%@')",message];
        [_myWebView stringByEvaluatingJavaScriptFromString:messageStr];
    }];
    [self.view addSubview:self.inputToolBar];
    
    //添加键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
  
    
}

//#pragma mark -appToJS
//-(void)sendTestMessageToJS:(UIButton*)sender{

//    
//    self.inputField.text = @"";
//    [self.view endEditing:YES];
//}

#pragma mark -监控键盘
-(void)keyBoardChangeFrame:(NSNotification*)noti{
    
    CGRect keyBoardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        if(keyBoardF.origin.y >= ScreenHeight - 64){
            CGFloat keyBoardY = ScreenHeight - KBottomH - 64;
            self.inputToolBar.frame = CGRectMake(0, keyBoardY, ScreenWidth, KBottomH);
        }else{
            CGFloat keyBoardY = keyBoardF.origin.y - KBottomH - 64;
            self.inputToolBar.frame = CGRectMake(0, keyBoardY, ScreenWidth, KBottomH);
        }
        
    }];
    
}

#pragma mark -uiwebview的代理方法
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //调用js中的方法
    [self.myWebView stringByEvaluatingJavaScriptFromString:@"setImageClickFunction()"];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"图片被点击了-----%@",[[request URL]absoluteString]);
    
    return YES;
}































@end
