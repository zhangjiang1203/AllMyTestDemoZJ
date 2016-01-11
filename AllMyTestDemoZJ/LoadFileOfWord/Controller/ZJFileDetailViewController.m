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
   
    [self downloadFileWithRequestURL:KDefaultFileURL downloadSuccess:^(NSURL *fileFullPAth) {
        //显示文件下载地址
        self.filePath = [NSString stringWithFormat:@"%@",fileFullPAth];
        [previewController reloadData];
    } downloadFailure:^(NSError *error) {
        //显示错误信息
    }];
    
}

-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSURL *itemURL ;
    if ([self.filePath isEqualToString:@"网络资源加载"]) {
        itemURL = [NSURL URLWithString:self.filePath];
    }else{
        itemURL = [NSURL fileURLWithPath:self.filePath];
    }
    return itemURL;
}


/*  @author Jakey
*  @brief  下载文件
*  @param requestURL 请求地址
*  @param success    下载成功回调
*  @param failure    下载失败回调
*/
- (void)downloadFileWithRequestURL:(NSString*)requestURL
               downloadSuccess:(void (^)(NSURL *fileFullPAth))success
               downloadFailure:(void (^)(NSError *error))failure{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath,NSURLResponse *response) {
        
        NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response,NSURL *filePath, NSError *error) {
        //此处已经在主线程了
       //开始显示下载文件
        success(filePath);
    }];
    
    [downloadTask resume];
    
}

@end
