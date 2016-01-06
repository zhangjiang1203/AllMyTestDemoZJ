//
//  ZJInputToolView.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/5.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJInputToolView.h"

@interface ZJInputToolView ()<UITextFieldDelegate>
@property (strong,nonatomic)UIButton *sendBtn;
@property (strong,nonatomic)UITextField *inputField;
@property (strong,nonatomic)SendMessageAction messageAction;
@end

@implementation ZJInputToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineLabel];
        
        CGFloat leftPadding = 15.0,topPadding = 5,buttonW = 80.0;
        CGFloat inputH = frame.size.height - 2*topPadding;
        CGFloat inputW = frame.size.width - 3*leftPadding - buttonW;
        self.inputField = [[UITextField alloc]initWithFrame:CGRectMake(leftPadding, topPadding, inputW, inputH)];
        self.inputField.borderStyle = UITextBorderStyleNone;
        self.inputField.returnKeyType = UIReturnKeyDone;
        self.inputField.font = KDefaultFont(15);
        self.inputField.delegate = self;
        self.inputField.placeholder = @"  输入要传达的内容";
        [self addSubview:self.inputField];
        
        self.sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.inputField.frame)+leftPadding, topPadding, buttonW, inputH)];
        [self.sendBtn setTitle:@"发送消息" forState:UIControlStateNormal];
        [self.sendBtn setTitleColor:KRGBA(0, 0, 0, 1) forState:UIControlStateNormal];
        self.sendBtn.titleLabel.font = KDefaultFont(15);
        self.sendBtn.layer.masksToBounds = YES;
        self.sendBtn.layer.cornerRadius = 5;
        self.sendBtn.layer.borderColor = KRGBA(30, 30, 30, 1).CGColor;
        self.sendBtn.layer.borderWidth = 0.5;
        [self.sendBtn addTarget:self action:@selector(buttonClickToNotice:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sendBtn];
        
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}


-(void)buttonClickToNotice:(UIButton*)sender{
    if (_messageAction) {
        NSString *messageStr = self.inputField.text;
        _messageAction(messageStr);
    }
    self.inputField.text = @"";
    [self.inputField endEditing:YES];
    
}

#pragma mark -传递block
-(void)sendMessageToJavaScript:(SendMessageAction)messageAction{
    if (messageAction) {
        _messageAction = messageAction;
    }
}

@end
