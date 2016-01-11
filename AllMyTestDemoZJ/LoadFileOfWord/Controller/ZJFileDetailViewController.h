//
//  ZJFileDetailViewController.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/11.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJBaseViewController.h"

@interface ZJFileDetailViewController : ZJBaseViewController
/**
 *  文件的路径
 */
@property (copy,nonatomic)NSString *resoursePath;
/**
 *  文件名
 */
@property (copy,nonatomic)NSString *fileName;

@end
