//
//  ZJNavAnimationViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/12/7.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJNavAnimationViewController.h"

@interface ZJNavAnimationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation ZJNavAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
        lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.contentView addSubview:lineLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"这就是我的顺序--%zd",indexPath.row];
    return cell;
}

@end
