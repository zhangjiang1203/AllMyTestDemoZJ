//
//  ZJAnimationChooseView.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 15/11/30.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJAnimationChooseView.h"

@interface ZJAnimationChooseView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *infoString;
}
@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSArray *animationArr;

@end

@implementation ZJAnimationChooseView

-(instancetype)initWithFrame:(CGRect)frame info:(NSString*)infoStr titles:(NSArray*)titles nameAction:(AnimationHandleAction)animationAction{
    self = [super initWithFrame:frame];
    if (self) {
        infoString = infoStr;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.animationAction = animationAction;
        self.animationArr = titles;        
        [self initMyTableViewUI];
    }
    return self;
}

#pragma mark -初始化view
-(void)initMyTableViewUI{
    
    CGFloat ViewW = self.frame.size.width;
    CGFloat ViewH = self.frame.size.height;
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, ViewW-30 , 18)];
    infoLabel.textColor = KRGBA(76, 76, 105, 1);
    infoLabel.text = infoString;
    infoLabel.font = KDefaultFont(15);
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:infoLabel];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(infoLabel.frame)+5, ViewW, 1)];
    lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineLabel];
    
    CGFloat TableY = CGRectGetMaxY(lineLabel.frame)+2;
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, TableY, ViewW, ViewH-TableY) style:UITableViewStylePlain];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self addSubview:self.myTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.animationArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"mySystemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-1, self.frame.size.width, 1)];
        lineLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.contentView addSubview:lineLabel];
    }
    cell.textLabel.text = self.animationArr[indexPath.row];
    cell.textLabel.textColor = KRGBA(76, 76, 105, 1);
    cell.textLabel.font = KDefaultFont(14);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //传递给代理函数
//    NSString *indexStr = [NSString stringWithFormat:@"%zd",indexPath.row];
    self.animationAction(indexPath.row);
}

@end
