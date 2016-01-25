//
//  ZJCustomCardView.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/25.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJCustomCardView.h"
#import "ZJCardView.h"
#define sizePercent 0.1
@interface ZJCustomCardView ()
{
    CGFloat viewW ;
    CGFloat viewH ;
}

@property (nonatomic,strong)NSMutableArray *cardViewsArr;

@end

@implementation ZJCustomCardView

-(instancetype)initWithFrame:(CGRect)frame finish:(AnimationFinishBlock)finishBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.cardViewsArr = [NSMutableArray array];
        self.finishBlock = finishBlock;
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        viewH = frame.size.height;
        viewW = frame.size.width;
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        for (int i = 0; i < 4; i++) {
            ZJCardView *cardView = [[[NSBundle mainBundle]loadNibNamed:@"ZJCardView" owner:self options:nil]lastObject];
            cardView.bounds = CGRectMake(0, 0, viewW, viewH);
//            cardView.center = CGPointMake(viewW/2, viewH/2 + i*10);
            [self setScaleWithPercent:(1-sizePercent*(3-i)) duration:0.25 view:cardView];
            CGPoint targetCenter = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2-(sizePercent*i*40));
            [self setCardCenter:targetCenter duration:0.25 view:cardView];
            [self.cardViewsArr addObject:cardView];
            [self addSubview:cardView];
        }
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerAction:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}


-(void)panGestureRecognizerAction:(UIPanGestureRecognizer*)recognizer{
    
    CGPoint transLcation = [recognizer translationInView:self];
    ZJCardView *cardView = self.cardViewsArr[self.cardViewsArr.count-1];
    cardView.center = CGPointMake(cardView.center.x+transLcation.x, cardView.center.y+transLcation.y);
    CGFloat XOffPercent = (cardView.center.x-CGRectGetWidth(self.bounds)/2)/(CGRectGetWidth(self.bounds)/2);
    CGFloat scalePercent =1-fabs(XOffPercent)*0.3;
    CGFloat rotation = M_PI_2/4*XOffPercent;
    
    [self setScaleWithPercent:scalePercent duration:0.25 view:cardView];
    [self setRotationWithAngle:rotation duration:0.25 view:cardView];
    [recognizer setTranslation:CGPointZero inView:self];
    for (int i = 1; i<self.cardViewsArr.count-1; i++) {
        CGFloat persent = fabs(XOffPercent);
        if (persent > 1) {
            persent = 1;
        }
        ZJCardView *subCard = self.cardViewsArr[i];
        [self setScaleWithPercent:1-(sizePercent*(self.cardViewsArr.count-1-i)-sizePercent*fabs(persent)) duration:0.25 view:subCard];
        CGPoint subCardCenter = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2+150-20-sizePercent*400*(i-1+(fabs(persent))));
        [self setCardCenter:subCardCenter duration:0.25 view:subCard];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (cardView.center.x>60&&cardView.center.x<CGRectGetWidth(self.bounds)-60) {
            ZJCardView * firstView = [self.cardViewsArr firstObject];
            [firstView removeFromSuperview];
            [self.cardViewsArr removeObjectAtIndex:0];
            [self cardRecenterOrDismiss:NO View:cardView];
        }
        else
        {
            [self cardRecenterOrDismiss:YES View:cardView];
            
        }
    }

    
}


-(void)cardRecenterOrDismiss:(BOOL)isDismiss View:(ZJCardView*)cardView{
    if (isDismiss) {
        [self setRotationWithAngle:0 duration:0.25 view:cardView];
        if (cardView.center.x<CGRectGetWidth(self.bounds)/2) {
            [self setCardCenter:CGPointMake(0-150, cardView.center.y) duration:0.25f view:cardView];
        }else{
            [self setCardCenter:CGPointMake(CGRectGetWidth(self.bounds)+cardView.bounds.size.width/2,cardView.center.y) duration:0.25f view:cardView ];
        }
    }else
    {
        
        [self setScaleWithPercent:1 duration:0.25 view:cardView];
        [self setRotationWithAngle:0 duration:0.25 view:cardView];

        CGPoint targetCenter = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2+150-20-(sizePercent*3*400));
        [self setCardCenter:targetCenter duration:0.25 view:cardView];
//        [self setCenter:targetCenter Duration:0.25 Card:card Index:3];
//        [self performSelector:@selector(cardRemove:) withObject:nil afterDelay:0.25];
        
    }
}



#pragma mark -放缩动画
-(void)setScaleWithPercent:(CGFloat)percent duration:(CGFloat)duration view:(ZJCardView*)cardView{
    POPBasicAnimation *scale = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scale.toValue = @(percent);
    scale.duration = duration;
    [cardView.layer pop_addAnimation:scale forKey:@"scale"];
    
}

#pragma mark -旋转动画
-(void)setRotationWithAngle:(CGFloat)angle duration:(CGFloat)duration view:(ZJCardView*)cardView{
    POPBasicAnimation *rotation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotation.duration = duration;
    rotation.toValue = @(angle);
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [cardView.layer pop_addAnimation:rotation forKey:@"rotation"];
}


#pragma mark -设置中心点
-(void)setCardCenter:(CGPoint)center duration:(CGFloat)duration view:(ZJCardView*)cardView{
    POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    basic.toValue = [NSValue valueWithCGPoint:center];
    basic.duration = duration;
    [basic setCompletionBlock:^(POPAnimation *anim, BOOL is) {
        cardView.hidden = NO;
    }];
    [cardView pop_addAnimation:basic forKey:@"center"];
}

//获取随机颜色
-(UIColor*)getRandomColor{
    CGFloat red = arc4random()%255;
    CGFloat blue = arc4random()%255;
    CGFloat green = arc4random()%255;
    
    return KRGBA(red, blue, green, 1);
    
}

@end
