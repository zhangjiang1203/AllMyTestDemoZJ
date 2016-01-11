//
//  ZJFileDetailViewController.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/11.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJBaseViewController.h"
#define KDefaultFileURL @"http://admin.52xiaoxin.com/static/template/demo_teacherBind.xls"
@interface ZJFileDetailViewController : ZJBaseViewController
/**
 *  文件的路径
 */
@property (nonatomic,copy)NSString *filePath;
/**
 *  文件名
 */
@property (nonatomic,copy)NSString *fileTitle;

@end
