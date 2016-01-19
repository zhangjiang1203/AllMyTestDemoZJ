//
//  ZJFileDetailViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/11.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJFileDetailViewController.h"
#import <QuickLook/QuickLook.h>

typedef void(^DownLoadSuccess)(NSString *filePathString);

@interface ZJFileDetailViewController ()<QLPreviewControllerDataSource>
{
    QLPreviewController *previewController;
}
@end

@implementation ZJFileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    self.title = self.fileTitle;
    //设置下载按钮
    if ([self.fileTitle isEqualToString:@"网络资源加载"]) {
        [self setRightButtonItem];
    }
    
    previewController = [[QLPreviewController alloc]init];
    previewController.dataSource = self;
    [self.view addSubview:previewController.view];
    
}

#pragma mark -直接返回上一层
-(void)setRightButtonItem{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
//    [rightBtn setImage:[UIImage imageNamed:@"back_press_base"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"下载" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = KDefaultFont(15);
    rightBtn.imageView.contentMode = UIViewContentModeLeft;
    [rightBtn addTarget:self action:@selector(downLoadFile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
     *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -7;
    
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, right];
}

#pragma mark -下载文件
-(void)downLoadFile:(UIButton*)sender{
    if ([sender.titleLabel.text isEqualToString:@"下载"]) {
        //初始化进度条
        MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.mode = MBProgressHUDModeDeterminate;
        HUD.labelText = @"Downloading...";
        HUD.square = YES;
        [HUD show:YES];
        [AFNClientHelper downLoadFileWithURLString:KDefaultFileURL path:^(NSString *pathString) {
            sender.hidden = YES;
            [HUD removeFromSuperview];
            _filePath = pathString;
            [previewController reloadData];
        }];

    }
}

-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSURL *itemURL = [NSURL fileURLWithPath:self.filePath];
    return itemURL;
}


@end
