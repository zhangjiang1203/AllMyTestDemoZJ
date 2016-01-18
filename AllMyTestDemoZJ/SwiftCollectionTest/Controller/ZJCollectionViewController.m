//
//  ZJCollectionViewController.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/18.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJCollectionViewController.h"
#import "AllMyTestDemoZJ-Swift.h"
#import "ZJRoundViewCell.h"
#import "ZJRoundCollectionLayout.h"
static NSString *identifier = @"mycell";

@interface ZJCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *itemArr;
}
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation ZJCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    itemArr = [NSMutableArray array];
    for (int i = 0; i< 10; i++) {
        [itemArr addObject:@(i)];
    }
    
    self.myCollectionView.collectionViewLayout = [[ZJRoundCollectionLayout alloc]init];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"ZJRoundViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addITemCells)];
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return itemArr.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZJRoundViewCell *cell = [ZJRoundViewCell cellWithCollectionView:collectionView WithIndexPath:indexPath];
    cell.headerImageView.image = [UIImage imageNamed:@"iconHeader"];
    return cell;
    
}

@end
