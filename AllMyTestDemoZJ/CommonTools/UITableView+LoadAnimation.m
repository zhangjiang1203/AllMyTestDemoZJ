//
//  UITableView+LoadAnimation.m
//  tableView动画实现
//
//  Created by zhangjiang on 15/6/23.
//  Copyright (c) 2015年 张江. All rights reserved.
//

#import "UITableView+LoadAnimation.h"

@implementation UITableView (LoadAnimation)
#pragma mark -实现animDirect的set和get方法
-(AnimationDirect *)animDirect{
    if (!self.animDirect) {
        
    }
    return self.animDirect;
}

-(void)setAnimDirect:(AnimationDirect *)animDirect{
    self.animDirect = animDirect;
}

-(void)reloadDataWithAnimate:(AnimationDirect)AnimDirect animationTime:(NSTimeInterval)animTime interVal:(NSTimeInterval)interTime{
    [self setContentOffset:self.contentOffset animated:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.hidden = YES;
        [self reloadData];
    } completion:^(BOOL finished) {
        self.hidden = NO;
        [self visibleRowsBeginAnimation:AnimDirect animationTime:animTime interVal:interTime];
    }];
}

-(void)visibleRowsBeginAnimation:(AnimationDirect)AnimDirect animationTime:(NSTimeInterval)animTime interVal:(NSTimeInterval)interVal{
    NSArray *visibleArr = [self indexPathsForVisibleRows];
    NSInteger count = visibleArr.count;
    switch (AnimDirect) {
        case AnimationDirectLeft:
        {
            for (NSInteger i = 0; i<count; i++) {
                NSIndexPath *path = visibleArr[i];
                UITableViewCell *cell = [self cellForRowAtIndexPath:path];
                cell.hidden = YES;
                CGPoint originPoint = cell.center;
                cell.center = CGPointMake(-cell.frame.size.width, originPoint.y);
                
                [UIView animateWithDuration:animTime+i*interVal delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    cell.center = CGPointMake(originPoint.x - 2.0, originPoint.y);
                    cell.hidden = NO;
                } completion:^(BOOL finished) {
                   [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                       cell.center = CGPointMake(originPoint.x + 2.0, originPoint.y);
                   } completion:^(BOOL finished) {
                       [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                           cell.center = originPoint;
                       } completion:nil];
                   }];
                }];
                
            }
        }
            break;
        case AnimationDirectRight:
        {
            for (NSInteger i = 0; i<count; i++) {
                NSIndexPath *path = visibleArr[i];
                UITableViewCell *cell = [self cellForRowAtIndexPath:path];
                cell.hidden = YES;
                CGPoint originPoint = cell.center;
                cell.center = CGPointMake(cell.frame.size.width*3.0, originPoint.y);
                
                [UIView animateWithDuration:animTime+i*interVal delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    cell.center = CGPointMake(originPoint.x + 2.0, originPoint.y);
                    cell.hidden = NO;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        cell.center = CGPointMake(originPoint.x - 2.0, originPoint.y);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            cell.center = originPoint;
                        } completion:nil];
                    }];
                }];
                
            }
        }
           
            break;
        case AnimationDirectTop:
        {
            for (NSInteger i = 0; i< count;i++){
                NSIndexPath *path = visibleArr[i];
                UITableViewCell *cell = [self cellForRowAtIndexPath:path];
                cell.hidden = YES;
                CGPoint originPoint = cell.center;
                cell.center = CGPointMake(originPoint.x, originPoint.y - 1000);
                [UIView animateWithDuration:animTime+i*interVal delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    cell.center = CGPointMake(originPoint.x, originPoint.y + 2.0);
                    cell.hidden = NO;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        cell.center = CGPointMake(originPoint.x, originPoint.y-2.0);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            cell.center = originPoint;
                        } completion:nil];
                    }];
                }];
            }
        }
            
            break;
        case AnimationDirectBottom:
        {
            for (NSInteger i = 0; i< count;i++){
                NSIndexPath *path = visibleArr[i];
                UITableViewCell *cell = [self cellForRowAtIndexPath:path];
                cell.hidden = YES;
                CGPoint originPoint = cell.center;
                cell.center = CGPointMake(originPoint.x, originPoint.y + 1000);
                [UIView animateWithDuration:animTime+i*interVal delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    cell.center = CGPointMake(originPoint.x, originPoint.y - 2.0);
                    cell.hidden = NO;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        cell.center = CGPointMake(originPoint.x, originPoint.y + 2.0);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            cell.center = originPoint;
                        } completion:nil];
                    }];
                }];
            }
        }
            break;
            
 
    }
}
@end
