//
//  ZJCircleView.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/26.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJCircleView.h"

@interface ZJCircleView ()

@property (nonatomic,strong)UILabel *infoLabel;
@property (nonatomic,strong)CAShapeLayer *circleLayer;

@end

@implementation ZJCircleView

-(void)awakeFromNib{
    
    [super awakeFromNib];

    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addShowCircleLayer];
        [self addShowInfoLabel];
        _circleWidth = 4.0;
        _circleColor = KRGBA(51, 255, 153, 1);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addShowCircleLayer];
        [self addShowInfoLabel];
        _circleWidth = 4.0;
        _circleColor = KRGBA(51, 255, 153, 1);
    }
    return self;
}

-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    _infoLabel.textColor = _titleColor;
}

-(void)setCircleColor:(UIColor *)circleColor{
    _circleColor = circleColor;
    _circleLayer.strokeColor = _circleColor.CGColor;
    
}

-(void)setCirclePercentage:(CGFloat)circlePercentage{
    _circlePercentage = circlePercentage;
    [self animationWithCirclePercentage:circlePercentage];
}

-(void)setCircleWidth:(CGFloat)circleWidth{
    _circleWidth = circleWidth;
    
    _circleLayer.lineWidth = _circleWidth;
}

#pragma mark - 添加显示百分比的label
-(void)addShowInfoLabel{
//    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _infoLabel.bounds = CGRectMake(0, 0, 100, 80);
        _infoLabel.text = @"0.0%";
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:_infoLabel];
//    }
}
#pragma mark -添加圆环
-(void)addShowCircleLayer{
//    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
//    }
    CGFloat radius = self.bounds.size.width/2 - _circleWidth;
    CGRect rect = CGRectMake(_circleWidth/2, _circleWidth/2, 2*radius, 2*radius);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    _circleLayer.lineWidth = _circleWidth;
    _circleLayer.path = path.CGPath;
    _circleLayer.strokeColor = _circleColor.CGColor;
    _circleLayer.fillColor = nil;
    _circleLayer.strokeEnd = 0.0;//修改这个控制显示的方向
    _circleLayer.lineJoin = kCALineJoinRound;
    _circleLayer.lineCap = kCALineCapRound;
    
    CAShapeLayer *beCircle = [CAShapeLayer layer];
    beCircle.lineCap = kCALineCapRound;
    beCircle.lineJoin = kCALineJoinRound;
    beCircle.strokeColor = [UIColor grayColor].CGColor;
    beCircle.lineWidth = 1.0;
    beCircle.strokeStart = 0.0;
    beCircle.strokeEnd = 1.0;
    beCircle.fillColor = nil;
    beCircle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(_circleWidth-1, _circleWidth-1, radius*2, radius*2) cornerRadius:radius - _circleWidth +1].CGPath;
    [self.layer addSublayer:beCircle];
    [self.layer addSublayer:_circleLayer];
    
}

-(void)animationWithCirclePercentage:(CGFloat)percentage{
    POPBasicAnimation *percent = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    percent.toValue = @(percentage);
    percent.duration = 1;
    percent.removedOnCompletion = NO;
    [_circleLayer pop_addAnimation:percent forKey:@"stork"];
    
    //设置数字的变化
    POPBasicAnimation *labelChange = [POPBasicAnimation animation];
    labelChange.duration = 1.0 ;
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"labelChange" initializer:^(POPMutableAnimatableProperty *prop) {
        
        [prop setReadBlock:^(id obj, CGFloat values[]) {
            values[0] = [[obj description]floatValue];
        }];
        
        [prop setWriteBlock:^(id obj, const CGFloat values[]) {
            NSString *string = [NSString stringWithFormat:@"%.2f%%",values[0]];
            [_infoLabel setText:string];
     
        }];
        prop.threshold = 0.01;
    }];
    
    labelChange.property = prop;
    labelChange.fromValue = @(0.0);
    labelChange.toValue = @(100.0f*percentage);
    [_infoLabel pop_addAnimation:labelChange forKey:@"labelChange"];
    
}

@end
