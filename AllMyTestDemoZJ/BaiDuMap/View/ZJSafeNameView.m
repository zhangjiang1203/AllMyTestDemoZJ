//
//  ZJSafeNameView.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/25.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJSafeNameView.h"

@interface ZJSafeNameView ()

@property (nonatomic,strong) UITextField *nameField;

@end

@implementation ZJSafeNameView

-(instancetype)initWithFrame:(CGRect)frame nameAction:(SafeNameHandleAction)nameHandleAction{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.nameHandleAction = nameHandleAction;
        [self setNameUIDataWithFrame:frame];
    }
    return self;
}

-(void)setAreaNameStr:(NSString *)areaNameStr{
    _areaNameStr = areaNameStr;
    self.nameField.text = _areaNameStr;
}

-(void)setNameUIDataWithFrame:(CGRect)frame{
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, frame.size.width-30, 18)];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = KRGBA(120, 120, 120, 1);
    infoLabel.font = KDefaultFont(13);
    infoLabel.text = @"设置安全区域的名称";
    [self addSubview:infoLabel];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(infoLabel.frame)+5, frame.size.width, 1)];
    lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineLabel];
    
    //添加输入框
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lineLabel.frame)+10, frame.size.width-30, 20)];
    self.nameField.textAlignment = NSTextAlignmentCenter;
    self.nameField.placeholder = @"请输入安全区域的名字";
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.font = KDefaultFont(14);
    self.nameField.textColor = KRGBA(30, 30, 30, 1);
    [self addSubview:self.nameField];
    
    //确定按钮
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.nameField.frame)+15, frame.size.width-40, 30)];
    confirmBtn.backgroundColor = KRGBA(20, 115, 213, 1);
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
}

-(void)confirmButtonClick:(UIButton*)sender{
    if (self.nameField.text.length) {
        self.nameHandleAction(self.nameField.text,YES);
    }
}

@end
