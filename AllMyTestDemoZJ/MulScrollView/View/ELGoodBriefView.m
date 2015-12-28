//
//  ELGoodBriefView.m
//  eLife
//
//  Created by zhangjiang on 15/7/1.
//  Copyright (c) 2015年 zhangjiang. All rights reserved.
//

#import "ELGoodBriefView.h"
#import "ELGoodBriefCell.h"
@interface ELGoodBriefView ()<UITableViewDataSource,UITableViewDelegate>{
    CGFloat contentOffsetY;
    CGFloat oldContentOffsetY;
    CGFloat newContentOffsetY;
    NSString *imageName;
}
@property (nonatomic,strong)UITableView *myTableView;

@end

@implementation ELGoodBriefView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMyTableViewWithFrame:frame];
    }
    return self;
}

-(void)initMyTableViewWithFrame:(CGRect)frame{
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    __weak typeof(self) weakSelf = self;
    self.myTableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.myTableView.mj_header endRefreshing];
    }];
    self.myTableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf.myTableView.mj_footer endRefreshing];
    }];
    
    [self addSubview:self.myTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ELGoodBriefCell *cell = [ELGoodBriefCell cellWithTableView:tableView];
    
    switch (self.goodType) {
        case KGoodTypeFood:
            imageName = @"food";
            break;
        case KGoodTypeShop:
            imageName = @"shop";
            break;
        case KGoodTypeHotel:
            imageName = @"hotel";
            break;
        case KGoodTypeParent:
            imageName = @"parent";
            break;
        case KGoodTypeTravel:
            imageName = @"travel";
            break;
        case KGoodTypeLeisure:
            imageName = @"leisure";
            break;
        case KGoodTypeLife:
            imageName = @"life";
            break;
        case KGoodTypeExercise:
            imageName = @"exercise";
            
            break;

    }
    cell.goodImageView.image = [UIImage imageNamed:imageName];
    [cell.praiseBtn addTarget:self action:@selector(pushToClickButton:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentBtn addTarget:self action:@selector(pushToClickButton:event:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)pushToClickButton:(UIButton*)sender event:(UIEvent*)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInView:self.myTableView];
    NSIndexPath *path = [self.myTableView indexPathForRowAtPoint:position];
    if (sender.tag == 1) {
        NSLog(@"开始点赞%zd--%zd",path.section,path.row);
        [[NSNotificationCenter defaultCenter]postNotificationName:KPraiseImage object:nil];
    }else{
        NSLog(@"开始评论%zd--%zd",path.section,path.row);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 205;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ELGoodBriefCell *cell = [ELGoodBriefCell cellWithTableView:tableView];
    
    if ([self.delegate respondsToSelector:@selector(clickCellToPush:imageName:frame:)]) {
        
        CGRect finalRect = [tableView rectForRowAtIndexPath:indexPath];
        //TODO:代理传回一个good的id，界面跳转之后根据id在请求数据
        [self.delegate clickCellToPush:indexPath.row imageName:imageName frame:finalRect];
    }
    
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    contentOffsetY = scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    oldContentOffsetY = scrollView.contentOffset.y;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    newContentOffsetY = scrollView.contentOffset.y;
//    if (newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY) {  // 向上滚动
//        //        NSLog(@"up");
//    } else if (newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY) { // 向下滚动
//        //        NSLog(@"down");
//    } else {
//        //        NSLog(@"dragging");
//    }
    
    if ((scrollView.contentOffset.y - contentOffsetY) > 5.0f) {  // 向上拖拽
        // 隐藏导航栏和选项栏
        if ([self.delegate respondsToSelector:@selector(dragToHiddenNavBar:)]) {
            [self.delegate dragToHiddenNavBar:YES];
        }
        
    } else if ((contentOffsetY - scrollView.contentOffset.y) > 5.0f) {   // 向下拖拽
        if ([self.delegate respondsToSelector:@selector(dragToHiddenNavBar:)]) {
            [self.delegate dragToHiddenNavBar:NO];
        }
        
    }
}
@end