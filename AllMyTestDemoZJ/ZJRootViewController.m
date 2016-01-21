//
//  ZJRootViewController.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/6.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJRootViewController.h"
#import "ZJBaiDuBaseViewController.h"
#import "ZJPaymentViewController.h"
#import "ZJMulScrollViewController.h"
#import "ZJCalendarViewController.h"
#import "ZJWebOperationViewController.h"
#import "ZJLoadFileViewController.h"
#import "ZJCollectionViewController.h"
#import "ZJBlueToothViewController.h"

#import "ZJBaseMapViewController.h"
#import "AppDelegate.h"
@interface ZJRootViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *viewControllerArr;
    NSArray *titleControllerArr;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ZJRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能选择";
    viewControllerArr = @[@"ZJBaiDuBaseViewController",@"ZJBaseMapViewController",@"ZJPaymentViewController",@"ZJMulScrollViewController",@"ZJCalendarViewController",@"ZJWebOperationViewController",@"ZJLoadFileViewController",@"ZJCollectionViewController",@"ZJBlueToothViewController"];
    titleControllerArr = @[@"百度地图",@"高德地图",@"移动支付",@"多视图滚动",@"自定义日历",@"WebView交互",@"预览Word,PPT,Excel,PDF",@"Collection样式",@"蓝牙测试",@"app传值"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleControllerArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"systemCell"];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-1, ScreenWidth, 1)];
        lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.contentView addSubview:lineLabel];
    }
    
    cell.textLabel.text = titleControllerArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //取消3D Touch功能
    AppDelegate *application = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [application init3DTouchActionShow:NO];
    
    if (indexPath.row != (titleControllerArr.count - 1)){
        NSString *name =  viewControllerArr[indexPath.row];
        Class class = NSClassFromString(name);
        UIViewController *controller = [[class alloc]init];
        controller.title = titleControllerArr[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        NSURL *url = [NSURL URLWithString:@"moviePlayerTest://hahahah"];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }else{
            [HUDHelper confirmMsg:@"亲，您还没有下砸该应用,点击确定去下载" continueBlock:^{
                NSLog(@"去下载");
            }];
        }
    }
    

}

@end
