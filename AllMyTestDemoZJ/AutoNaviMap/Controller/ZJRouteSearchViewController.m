//
//  ZJRouteSearchViewController.m
//  ePark
//
//  Created by zjhaha on 15/12/23.
//  Copyright © 2015年 zjhaha. All rights reserved.
//

#import "ZJRouteSearchViewController.h"
#import "UIScrollView+EmptyDataSet.h"
@interface ZJRouteSearchViewController ()<UISearchBarDelegate,AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
{
    AMapSearchAPI *searchPOI;
    
}

@property (strong,nonatomic)NSMutableArray *resultArr;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ZJRouteSearchViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButtonItem];
    [self initMySearchBar];
}

-(void)initMySearchBar{
    
    self.resultArr = [NSMutableArray array];
    //添加搜索框
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    searchView.layer.cornerRadius = 5;
    searchView.layer.masksToBounds = YES;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索停车地点";
    [searchBar becomeFirstResponder];
    [searchView addSubview:searchBar];
    self.navigationItem.titleView = searchView;
    
    searchPOI = [[AMapSearchAPI alloc]init];
    searchPOI.delegate = self;
    
    self.myTableView.emptyDataSetDelegate = self;
    self.myTableView.emptyDataSetSource = self;
    
}

#pragma mark -searchbar的代理方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"开始搜索");

}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //构造AMapPOIKeywordsSearchRequest对象，设置关键字请求参数
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = searchText;
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"地名地址信息";
    request.sortrule = 0;
    request.requireExtension = YES;
    
    //发起周边搜索
    [searchPOI AMapPOIKeywordsSearch:request];
}

#pragma mark -POI搜索代理方法
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if(response.pois.count == 0)
    {
        [MBProgressHUD show:@"该关键字暂无对应数据😭" icon:nil view:self.navigationController.view];
        return;
    }
    if (self.resultArr.count) {
        [self.resultArr removeAllObjects];
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
    for (AMapPOI *resultPOI in response.pois) {
        [self.resultArr addObject:resultPOI];
    }
    [self.myTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArr.count;
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
    AMapPOI *resultPOI = self.resultArr[indexPath.row];
    cell.textLabel.text = resultPOI.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMapPOI *resultPOI = self.resultArr[indexPath.row];
    self.selectedBlock(resultPOI);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.navigationController.view endEditing:YES];
}

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text =@"输入关键字开始搜索" ;
    
    NSDictionary *attributes = @{NSFontAttributeName: KDefaultFont(18),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = @"输入关键字开始搜索";
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
//}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"emptyCalendarData"];
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
