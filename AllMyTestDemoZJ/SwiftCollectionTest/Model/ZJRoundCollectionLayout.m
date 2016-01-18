//
//  ZJRoundCollectionLayout.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/18.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJRoundCollectionLayout.h"
#define KItemSize 70
@interface ZJRoundCollectionLayout ()
{
    NSInteger _cellCount;
    CGSize _collectionSize;
    CGPoint _centerPoint;
    CGFloat _radius;
    NSMutableArray *insertIndexArr;
}

@end

@implementation ZJRoundCollectionLayout


-(void)prepareLayout{
    [super prepareLayout];
    insertIndexArr = [NSMutableArray array];
    _collectionSize = self.collectionView.frame.size;
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    _radius = MIN(_collectionSize.width, _collectionSize.height);
    _centerPoint = CGPointMake(_collectionSize.width/2, _collectionSize.height/2);
    
}

-(CGSize)collectionViewContentSize{
    return _collectionSize;
}


-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *rectArr = [NSMutableArray array];
    
    for (int i = 0 ; i < _cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *atts = [self layoutAttributesForItemAtIndexPath:indexPath];
        [rectArr addObject:atts];
    }
    return rectArr;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attrs.size = CGSizeMake(KItemSize, KItemSize);
    CGFloat x = _centerPoint.x + _radius * cos(2*indexPath.item * M_PI / (double)_cellCount);
    CGFloat y = _centerPoint.y + _radius * sin(2*indexPath.item * M_PI / (double)_cellCount);
    attrs.center = CGPointMake(x, y);
    return attrs;
    
}

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    
    UICollectionViewLayoutAttributes *attrs = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    if ([insertIndexArr containsObject:itemIndexPath]) {
        attrs = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        attrs.alpha = 0.0;
        attrs.center = CGPointMake(_centerPoint.x, _centerPoint.y);
    }
    return attrs;
    
}

-(void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems{
    [super prepareForCollectionViewUpdates:updateItems];
    for (UICollectionViewUpdateItem *update in updateItems) {
        if (update.updateAction == UICollectionUpdateActionInsert) {
            [insertIndexArr addObject:update];
        }
    }
}







@end
