//
//  ZJPlaceHolderTextView.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/26.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJPlaceHolderTextView.h"

@interface ZJPlaceHolderTextView ()

@property (nonatomic,strong)UILabel *placeHolderLabel;
@end

@implementation ZJPlaceHolderTextView
-(void)awakeFromNib{
    [super awakeFromNib];

    self.placeFont = self.font;
    self.placeHolder = @"";
    self.placeColor = [UIColor lightGrayColor];
    //设置一个通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textValueChange) name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}


-(void)setPlaceColor:(UIColor *)placeColor{
    _placeColor = placeColor;
}

-(void)setPlaceHolder:(NSString *)placeHolder{
    if (_placeHolder != placeHolder) {
        _placeHolder = placeHolder;
        [_placeHolderLabel removeFromSuperview];
        _placeHolderLabel = nil;
        [self setNeedsDisplay];
    }
    
}


-(void)textValueChange{
    
    if ([self.placeHolder length] == 0) {
        return;
    }
    
    if ([[self text]length] > 0) {
        [_placeHolderLabel setAlpha:0.0];
    }else{
        [_placeHolderLabel setAlpha:1.0];
    }
    
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if ([[self placeHolder] length] > 0) {
        if (_placeHolderLabel == nil) {
            _placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, self.frame.size.width-16, 18)];
            _placeHolderLabel.textColor = self.placeColor;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.numberOfLines = 0;
            [_placeHolderLabel setAlpha:0.0];
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.text = self.placeHolder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if ([[self text]length] == 0 && self.placeHolder.length >0) {
        [_placeHolderLabel setAlpha:1.0];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
