//
//  ZJOpenFileViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/11.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJOpenFileViewController.h"
#import "ZJFileDetailViewController.h"
@interface ZJOpenFileViewController ()
@end

@implementation ZJOpenFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
}



- (IBAction)openFileClick:(UIButton *)sender {
    NSString *filePath;
    NSString *fileTitle;
    switch (sender.tag) {
        case 1://word
            filePath = [[NSBundle mainBundle]
                        pathForResource:@"Swift学习笔记" ofType:@"doc"];
            fileTitle = @"Swift学习笔记";
            
            break;
        case 2://excel
            filePath = [[NSBundle mainBundle]
                        pathForResource:@"研发部员工通讯录" ofType:@"xls"];
            fileTitle = @"研发部员工通讯录";
            break;
        case 3://ppt
            filePath = [[NSBundle mainBundle]
                        pathForResource:@"ppt文档" ofType:@"ppt"];
            fileTitle = @"ppt文档";
            break;
        case 4://pdf
            filePath = [[NSBundle mainBundle]
                        pathForResource:@"pdf文档的翻译" ofType:@"pdf"];
            fileTitle = @"pdf文档的翻译";
            break;
    }
    
    ZJFileDetailViewController *VC = [[ZJFileDetailViewController alloc]init];
    VC.resoursePath = filePath;
    VC.fileName = fileTitle;
    [self.navigationController pushViewController:VC animated:YES];
    
    
}

@end
