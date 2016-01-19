//
//  ZJAFNTestViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/19.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJAFNTestViewController.h"
#import "NSString+URLCode.h"
@interface ZJAFNTestViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@end

@implementation ZJAFNTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = 70;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    NSString *urlString = [NSString stringWithFormat:@"http://www.omdbapi.com/?t=%@&y=&plot=full&r=json",[textField.text URLEncodeString]];
    //开始请求网络
    [MBProgressHUD show:@"加载中……" icon:@"" view:nil];
    [AFNClientHelper getWithURLString:urlString param:nil success:^(NSDictionary *dictData) {
        [MBProgressHUD hideHUD];
        NSString *title = dictData[@"Title"];
        if (title.length) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _titleLabel.text = dictData[@"Title"];
                _infoLabel.text = dictData[@"Plot"];
                _headerImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dictData[@"Poster"]]]];
            });

        }else{
            [MBProgressHUD show:@"暂无此影片信息" icon:@"" view:nil];
        }
    } fail:^(NSString *errorStr) {
        [MBProgressHUD hideHUD];
    }];
    
    return YES;
}

@end
