//
//  WCSafeAreaView.m
//  Xiaoxin
//
//  Created by zhangjiang on 15/9/9.
//  Copyright (c) 2015年 juzi. All rights reserved.
//

#import "WCSafeAreaView.h"

@interface WCSafeAreaView ()
@property (nonatomic, assign) CGPoint location;

@end

@implementation WCSafeAreaView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KRGBA(0, 0, 0, 0.5);
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([self.delegate respondsToSelector:@selector(touchesBegan:)]) {
        [self.delegate touchesBegan:touch];
    }
    
    self.location = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    if ([self.delegate respondsToSelector:@selector(touchesMoved:)]) {
        [self.delegate touchesMoved:touch];
    }
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blueColor] colorWithAlphaComponent:0.7].CGColor);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, self.location.x, self.location.y);
    CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
    CGContextStrokePath(ctx);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.location = currentLocation;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    if ([self.delegate respondsToSelector:@selector(touchesEnded:)]) {
        [self.delegate touchesEnded:touch];
    }
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blueColor] colorWithAlphaComponent:0.7].CGColor);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, self.location.x, self.location.y);
    CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
    CGContextStrokePath(ctx);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.location = currentLocation;
}

@end
