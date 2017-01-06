//
//  ZJDashboardView.m
//  DashboardDemo
//
//  Created by pg on 2017/1/5.
//  Copyright © 2017年 bestdew. All rights reserved.
//

#import "ZJDashboardView.h"

@interface ZJDashboardView ()

@property (nonatomic,strong) CAShapeLayer *progressLayer;

@property (nonatomic,strong) CATextLayer *textLayer;
@end

@implementation ZJDashboardView

-(UIColor *)circleColor{
    if (_circleColor == nil) {
        _circleColor = [UIColor whiteColor];
    }
    return _circleColor;
}

-(UIColor *)smallDegreeColor{
    if (_smallDegreeColor == nil) {
        _smallDegreeColor = [UIColor colorWithRed:0.22 green:0.66 blue:0.87 alpha:1.0];
    }
    return _smallDegreeColor;
}

-(NSArray<UIColor *> *)gradientColors{
    if (_gradientColors == nil) {
        _gradientColors = @[(id)[[UIColor colorWithRed:0.09 green:0.58 blue:0.15
                                alpha:1.00] CGColor],
                            (id)[[UIColor colorWithRed:0.20 green:0.63 blue:0.25 alpha:1.00] CGColor],
                            (id)[[UIColor colorWithRed:0.60 green:0.82 blue:0.22 alpha:1.00] CGColor],
                            (id)[[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.00] CGColor]];
    }
    return _gradientColors;
}

-(void)setStrokeEnd:(CGFloat)strokeEnd{
    _strokeEnd = strokeEnd;
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0.5f];
    _progressLayer.strokeEnd = self.strokeEnd;
    [CATransaction commit];
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.strokeEnd = 0;
        self.backgroundColor = [UIColor colorWithRed:0.14 green:0.59 blue:0.83 alpha:1.00];
        [self setUpMyDashBoard];
    }
    return self;
}

-(void)setUpMyDashBoard{
    //外环
    CAShapeLayer *outCircle = [self drawMyCircleWithRadius:147.5];
    [self.layer addSublayer:outCircle];
    
    //内环
    CAShapeLayer *inCircle = [self drawMyCircleWithRadius:82.5];
    [self.layer addSublayer:inCircle];
    
    //绘制进度层
    UIBezierPath *progressBezier = [UIBezierPath bezierPathWithArcCenter:self.center
                                                                  radius:115
                                                              startAngle:-M_PI
                                                                endAngle:0
                                                               clockwise:YES];
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.lineWidth = 60;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.strokeColor = self.circleColor.CGColor;
    progressLayer.strokeStart = 0;
    progressLayer.strokeEnd = self.strokeEnd;
    progressLayer.path = progressBezier.CGPath;
    _progressLayer = progressLayer;
    [self.layer addSublayer:progressLayer];
    
    [_progressLayer addObserver:self forKeyPath:@"strokeEnd" options:NSKeyValueObservingOptionNew context:nil];
    
    //渐变图层
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame = self.bounds;
    [colorLayer setColors:self.gradientColors];
    colorLayer.startPoint = (CGPoint){0,0};
    colorLayer.endPoint = (CGPoint){1.0,0};
    [colorLayer setLocations:@[@0,@0.25,@0.75,@1]];
    [colorLayer setMask:progressLayer];
    [self.layer addSublayer:colorLayer];
    
    CGFloat perGraduation = M_PI/50.0;//一刻度线的弧度值
    CGFloat perLineWidth = perGraduation/5.0;//刻度线的弧度
    //开始绘制标签
    for (int i = 1;i < 50 ;i++){
        CGFloat startAngel = -M_PI + i*perGraduation;
        CGFloat endAngel = startAngel+perLineWidth;
        UIBezierPath *tempPath = [UIBezierPath bezierPathWithArcCenter:self.center
                                                                radius:140
                                                            startAngle:startAngel
                                                              endAngle:endAngel
                                                             clockwise:YES];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor clearColor].CGColor;
        if (i % 5 == 0) {
            //添加刻度指示
            CGPoint labelPoint = [self calculateLabelPositionWithArcCenter:self.center angle:-startAngel];
            //添加label
            CATextLayer *myLabelLayer = [[CATextLayer alloc]init];
            myLabelLayer.frame = CGRectMake(labelPoint.x-10, labelPoint.y-10, 20, 20);
            myLabelLayer.contentsScale = [UIScreen mainScreen].scale;
            myLabelLayer.string = [NSString stringWithFormat:@"%zd",i*2];
            myLabelLayer.fontSize = 13;
            myLabelLayer.foregroundColor = self.circleColor.CGColor;
            myLabelLayer.alignmentMode = kCAAlignmentCenter;
            [self.layer addSublayer:myLabelLayer];
            
            layer.strokeColor = [UIColor whiteColor].CGColor;
            layer.lineWidth = 10;
        }else{
            layer.strokeColor = self.smallDegreeColor.CGColor;
            layer.lineWidth = 5;
        }
        layer.path = tempPath.CGPath;
        [self.layer addSublayer:layer];
    }
    //显示进度的label
    CATextLayer *textLayer = [[CATextLayer alloc]init];
    textLayer.frame = CGRectMake(self.center.x-40, self.center.y-50, 80, 50);
    textLayer.string = [NSString stringWithFormat:@"%.0f%@",self.strokeEnd,@"%"];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.font = (__bridge CFTypeRef _Nullable)([UIFont systemFontOfSize:35]);
    textLayer.foregroundColor = self.circleColor.CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    _textLayer = textLayer;
    [self.layer addSublayer:textLayer];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"获取到的数据变化====%@",change);
    if ([keyPath isEqualToString:@"strokeEnd"]) {
        CGFloat progress = [change[@"new"] floatValue]*100;
        _textLayer.string = [NSString stringWithFormat:@"%.0f%@",progress,@"%"];
    }
}

-(CGPoint)calculateLabelPositionWithArcCenter:(CGPoint)center angle:(CGFloat)angle{
    CGFloat radius = 125;
    CGFloat x = radius*cosf(angle);
    CGFloat y = radius*sinf(angle);
    
    return CGPointMake(center.x+x, center.y-y);
}

-(CAShapeLayer*)drawMyCircleWithRadius:(CGFloat)radius{
    UIBezierPath *bezier = [UIBezierPath bezierPathWithArcCenter:self.center
                                                          radius:radius
                                                      startAngle:-M_PI
                                                        endAngle:0
                                                       clockwise:YES];
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.lineWidth = 5;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.strokeColor = self.circleColor.CGColor;
    shape.path = bezier.CGPath;
    
    return shape;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGFloat radio = arc4random_uniform(100)/100.0;
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0.5f];
    _progressLayer.strokeEnd = radio;
    [CATransaction commit];
}

-(void)dealloc{
    [_progressLayer removeObserver:self forKeyPath:@"strokeEnd"];
}

@end
