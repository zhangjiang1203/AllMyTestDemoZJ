//
//  ZJAreaListViewController.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/12.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJAreaListViewController.h"
#import "ZJSetttingAreaViewController.h"
#import "ZJSafeAreaDetailViewController.h"
//#import "MJExtension.h"
@interface ZJAreaListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *areaListArr;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation ZJAreaListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //拿到安全区域的数据
    areaListArr = [ZJAreaDataManager getAllAreaList];
    [self.myTableView reloadDataWithAnimate:AnimationDirectRight animationTime:0.3 interVal:0.05];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全区域";
    [TableEmptyData shareManager].emptyDataColor = UIColorFromRGB(0xF2F2F2);
    [self.myTableView setMethodDelegateAndDataSource];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return areaListArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
        lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.contentView addSubview:lineLabel];
    }
    ZJAreaModel *model = areaListArr[indexPath.row];
    cell.textLabel.text = model.areaName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZJSafeAreaDetailViewController *VC = [[ZJSafeAreaDetailViewController alloc]init];
    VC.areaModel = areaListArr[indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark -添加新的安全区域
- (IBAction)addAndSetNewAreaList:(UIButton *)sender {
    ZJSetttingAreaViewController *VC = [[ZJSetttingAreaViewController alloc]initWithNibName:@"ZJSetttingAreaViewController" bundle:nil];
    VC.safeType = KSafeAreaTypeAdd;
    [self.navigationController pushViewController:VC animated:YES];
}
@end