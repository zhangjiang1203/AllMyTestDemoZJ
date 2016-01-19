//
//  ZJCollectionViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/18.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJCollectionViewController.h"
#import "ZJRoundViewCell.h"
#import "ZJRoundCollectionLayout.h"

@interface ZJCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *itemArr;
}
@property (strong, nonatomic)  UICollectionView *myCollectionView;


@end

@implementation ZJCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightButtonItem];
    itemArr = [NSMutableArray array];
    for (int i = 0; i< 10; i++) {
        [itemArr addObject:@(i)];
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(80, 80);
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    
    self.myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    [self.myCollectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
    [self.view addSubview:self.myCollectionView];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addItemCells)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired  = 1;
    [self.myCollectionView addGestureRecognizer:singleTapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteItemCells)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [self.myCollectionView addGestureRecognizer:doubleTapGesture];
    //双击时，单击事件不执行
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
}


#pragma mark -右边的按钮点击事件
-(void)setRightButtonItem{
    UIButton *changeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    [changeBtn setTitle:@"切换布局" forState:UIControlStateNormal];
    changeBtn.titleLabel.font = KDefaultFont(14);
    changeBtn.imageView.contentMode = UIViewContentModeLeft;
    [changeBtn addTarget:self action:@selector(changeCollectionLayout:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *Right = [[UIBarButtonItem alloc]initWithCustomView:changeBtn];
    
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
     *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -7;
    
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, Right];
}
-(void)changeCollectionLayout:(UIButton*)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected ){
        ZJRoundCollectionLayout *layout = [[ZJRoundCollectionLayout alloc]init];
        layout.itemSize = CGSizeMake(80, 80);
        [self.myCollectionView setCollectionViewLayout:layout animated:YES];
        
    }else{
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(80, 80);
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
        [self.myCollectionView setCollectionViewLayout:flowLayout animated:YES];
    }
    
    
}

#pragma mark -增加cell
-(void)addItemCells{
    [itemArr addObject:@15];
    [self.myCollectionView reloadData];
}

-(void)deleteItemCells{
    if (itemArr.count) {
        [itemArr removeLastObject];
        [self.myCollectionView reloadData];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return itemArr.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZJRoundViewCell *cell = [ZJRoundViewCell cellWithCollectionView:collectionView WithIndexPath:indexPath];
    cell.headerImageView.image = [UIImage imageNamed:@"iconHeader"];
    cell.layer.cornerRadius = cell.frame.size.width/2;
    cell.layer.masksToBounds = YES;
    return cell;
}
@end
