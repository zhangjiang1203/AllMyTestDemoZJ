//
//  ZJCustomeSegment.m
//  CostumeSegmentDome
//
//  Created by zjhaha on 15/12/28.
//  Copyright © 2015年 zjhaha. All rights reserved.
//

#import "ZJCustomeSegment.h"
static const NSTimeInterval duration = 0.3;
@interface ZJCustomeSegment ()
{
    CGFloat _labelWidth;
    CGFloat _viewHeight;
    CGFloat _viewWidth;
    
}

@property (strong,nonatomic) UIView *heightLightView;//显示高亮的背景视图
@property (strong,nonatomic) UIView *titleHeightView;//显示文字高亮的视图
@property (strong,nonatomic) UIView *animationView;//动画view
/**
 *  点击按钮的回调
 */
@property (strong,nonatomic)ActionHandlerClick clickActionBlock;

@end

@implementation ZJCustomeSegment

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _viewWidth = frame.size.width;
        _viewHeight = frame.size.height;
    }
    return self;
}

-(void)layoutSubviews{
    [self setDefaultData];
    [self createBottomLabel];
    [self createHeightLightTitleView];
    [self createTitleButton];
    UIButton *defaultBtn = (UIButton *)[self viewWithTag:0];
    [self titleButtonClick:defaultBtn];
}

//-(void)setTitleArr:(NSArray *)titleArr{
//    _titleArr = titleArr;
//    [self setDefaultData];
//    [self createBottomLabel];
//    [self createHeightLightTitleView];
//    [self createTitleButton];
//}

-(void)setDefaultData{
    if (_titleArr == nil) {
        _titleArr = @[@"Test1",@"Test2",@"Test3"];
        
    }
    
    if (_backImageColor == nil) {
        _backImageColor = [UIColor redColor];
    }
    
    if (_defaultTitleColor == nil) {
        _defaultTitleColor = [UIColor blackColor];
    }
    
    if (_heightColor == nil) {
        _heightColor = [UIColor whiteColor];
    }
    
    if (_defaultTitleFont == nil) {
        _defaultTitleFont = [UIFont systemFontOfSize:14];
    }
    
    if (_heightTitleFont == nil) {
        _heightTitleFont = [UIFont systemFontOfSize:15];
    }
    
    _labelWidth = _viewWidth / _titleArr.count;
}

/**
 *  创建底层的title视图
 */

-(void)createBottomLabel{
    for (int i = 0; i < _titleArr.count; i++) {
        UILabel *titleLabel = [self setLabelPropertyWithIndex:i titleColor:_defaultTitleColor];
        titleLabel.font = _defaultTitleFont;
        [self addSubview:titleLabel];
    }
}

/**
 *  设置Label的各种属性
 */
-(UILabel *)setLabelPropertyWithIndex:(NSInteger)index titleColor:(UIColor *)textcolor{
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:[self getCurrentRectWithIndex:index]];
    tempLabel.text = _titleArr[index];
    tempLabel.textColor = textcolor;
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.minimumScaleFactor = 0.1f;
    
    return tempLabel;
}

/**
 *  计算当前高亮的frame
 */
-(CGRect)getCurrentRectWithIndex:(NSInteger)index{
    return CGRectMake(_labelWidth*index, 0, _labelWidth, _viewHeight);
}

/**
 *  创建高亮title
 */
-(void)createHeightLightTitleView
{
    CGRect titleRect = CGRectMake(0, 0, _labelWidth, _viewHeight);
    
    _heightLightView = [[UIView alloc]initWithFrame:titleRect];
    _heightLightView.clipsToBounds = YES;
    
    _animationView = [[UIView alloc]initWithFrame:titleRect];
    _animationView.backgroundColor = _backImageColor;
    _animationView.layer.cornerRadius = 5;
    _animationView.layer.masksToBounds = YES;
    [_heightLightView addSubview:_animationView];
    
    _titleHeightView = [[UIView alloc]initWithFrame:self.frame];
    
    for (int i = 0; i < _titleArr.count; i++) {
        UILabel *heightLabel = [self setLabelPropertyWithIndex:i titleColor:_heightColor];
        heightLabel.font = _heightTitleFont;
        [_titleHeightView addSubview:heightLabel];
    }
    [_heightLightView addSubview:_titleHeightView];
    [self addSubview:_heightLightView];
    
}

/**
 *  创建按钮
 */
-(void)createTitleButton{
    for (int i = 0; i < _titleArr.count; i++) {
        UIButton *heightLabelBtn = [[UIButton alloc]initWithFrame:[self getCurrentRectWithIndex:i]];
        heightLabelBtn.tag = i;
        [heightLabelBtn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:heightLabelBtn];
    }
}

-(void)titleButtonClick:(UIButton*)sender{
    
    NSInteger index = sender.tag;
    //block回执
    if(self.clickActionBlock){
        self.clickActionBlock(_titleArr[index],index);
    }
    CGRect frame = [self getCurrentRectWithIndex:index];
    CGRect changeFrame = [self getCurrentRectWithIndex:-index];
    
    [UIView animateWithDuration:duration animations:^{
        _heightLightView.frame = frame;
        _titleHeightView.frame = changeFrame;
    } completion:^(BOOL finished) {
        NSLog(@"动画执行完毕");
    }];
}

-(void) setButtonOnClickBlock: (ActionHandlerClick) block {
    if (block) {
        _clickActionBlock = block;
    }
}
@end
