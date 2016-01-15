//
//  UIScrollView+ZJEmptyData.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/15.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableEmptyData : UIView

@property(nonatomic,strong)NSString *emptyDataString;
@property(nonatomic,strong)NSString *subEmptyDataString;
@property(nonatomic,strong)NSString *emptyDataImage;
@property(nonatomic,strong)UIColor  *emptyDataColor;

+ (TableEmptyData *)shareManager;

@end


@interface UIScrollView (ZJEmptyData)<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

- (void)setMethodDelegateAndDataSource;

@end


//方法示例
//开启空白检测
//[TableEmptyData shareManager].emptyDataColor=UIColorFromRGB(0xF2F2F2);
//[self.allDaySportTableView MethodsEmptyData];