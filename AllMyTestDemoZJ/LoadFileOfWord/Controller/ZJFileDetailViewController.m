//
//  ZJFileDetailViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/11.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJFileDetailViewController.h"
#import <QuickLook/QuickLook.h>
@interface ZJFileDetailViewController ()<QLPreviewControllerDataSource>
{
    QLPreviewController *previewController;
}

@end

@implementation ZJFileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.fileName;
    self.view.clipsToBounds = YES;
    previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    
    [self.view addSubview:previewController.view];
}

-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    
    NSURL *myQLDocument = [NSURL fileURLWithPath:self.resoursePath];
    return myQLDocument;
}

@end
