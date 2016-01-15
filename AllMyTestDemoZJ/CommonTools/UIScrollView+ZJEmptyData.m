//
//  UIScrollView+ZJEmptyData.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/15.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "UIScrollView+ZJEmptyData.h"

@interface TableEmptyData ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>


@end

@implementation TableEmptyData

+ (TableEmptyData *)shareManager {
    static TableEmptyData *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (manager == nil) {
            manager = [[TableEmptyData alloc]init];
        }
    });
    return manager;
}
- (instancetype)init
{
    self=[super init];
    if (self) {
        _emptyDataString = @"暂无数据";
        _subEmptyDataString = @"请稍后再试";
        _emptyDataImage = @"nodata";
        _emptyDataColor = [UIColor whiteColor];
    }
    return self;
}
- (void)setEmptyDataColor:(UIColor *)emptyDataColor
{
    _emptyDataColor = emptyDataColor;
}
- (void)setSubEmptyDataString:(NSString *)subEmptyDataString
{
    _subEmptyDataString = subEmptyDataString;
}
- (void)setEmptyDataString:(NSString *)emptyDataString
{
    _emptyDataString = emptyDataString;
}
- (void)setEmptyDataImage:(NSString *)emptyDataImage
{
    _emptyDataImage = emptyDataImage;
}

@end


@implementation UIScrollView (ZJEmptyData)

- (void)setMethodDelegateAndDataSource
{
    self.emptyDataSetSource=self;
    self.emptyDataSetDelegate=self;
}


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text =[TableEmptyData shareManager].emptyDataString ;
    
    NSDictionary *attributes = @{NSFontAttributeName: KDefaultFont(18),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [TableEmptyData shareManager].subEmptyDataString;
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: KDefaultFont(13),
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:[TableEmptyData shareManager].emptyDataImage];
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [TableEmptyData shareManager].emptyDataColor;
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
@end
