//
//  ZJLoadFileViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/11.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJLoadFileViewController.h"
#import "ZJFileDetailViewController.h"
@interface ZJLoadFileViewController ()

@end

@implementation ZJLoadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    
}

- (IBAction)loadFilePathClick:(UIButton *)sender {
    
    NSString *fileTitle = @"",*filePathStr = @"";
    switch (sender.tag) {
        case 1://word
        {
            fileTitle = @"Swift学习笔记";
            filePathStr = [[NSBundle mainBundle]pathForResource:fileTitle ofType:@"doc"];
        }
            break;
            
        case 2://excel
        {
            fileTitle = @"研发部员工通讯录";
            filePathStr = [[NSBundle mainBundle]pathForResource:fileTitle ofType:@"xls"];
        }
            break;
        case 3://ppt
        {
            fileTitle = @"ppt文档";
            filePathStr = [[NSBundle mainBundle]pathForResource:fileTitle ofType:@"ppt"];
        }
            break;
        case 4://pdf
        {
            fileTitle = @"pdf文档的翻译";
            filePathStr = [[NSBundle mainBundle]pathForResource:fileTitle ofType:@"pdf"];
        }
            break;
        case 5://网络资源
        {
            fileTitle = @"网络资源加载";
            filePathStr = KDefaultFileURL;
        }
            break;
    }
    ZJFileDetailViewController *VC = [[ZJFileDetailViewController alloc]init];
    VC.filePath = filePathStr;
    VC.fileTitle = fileTitle;
    [self.navigationController pushViewController:VC animated:YES];
    
    
}


@end
