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
#import "MJExtension.h"
@interface ZJAreaListViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
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
    self.myTableView.emptyDataSetDelegate = self;
    self.myTableView.emptyDataSetSource = self;
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


#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text =@"您还没未添加安全区域，赶快添加吧" ;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    //    NSString *text = @"没有作业详情";
    //
    //    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    //    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    //    paragraph.alignment = NSTextAlignmentCenter;
    //
    //    NSDictionary *attributes = @{NSFontAttributeName: KDefaultFont(13),
    //                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
    //                                 NSParagraphStyleAttributeName: paragraph};
    //
    //    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    return nil;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text = @"我要添加安全区域>>>>>>";
    UIColor *textColor =  [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] ;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0],
                                 NSForegroundColorAttributeName: textColor};
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributedTitle;
}
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [self addAndSetNewAreaList:nil];
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"nodata"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

#pragma mark - DZNEmptyDataSetDelegate Methods
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
@end
