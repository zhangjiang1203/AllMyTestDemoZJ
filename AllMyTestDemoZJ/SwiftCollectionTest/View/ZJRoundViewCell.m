//
//  ZJRoundViewCell.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/18.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "ZJRoundViewCell.h"

@interface ZJRoundViewCell ()


@end

@implementation ZJRoundViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView WithIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ZJRoundViewCell";
    ZJRoundViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

- (void)awakeFromNib {
    self.layer.cornerRadius = self.bounds.size.width/2;
    self.layer.masksToBounds = YES;
    
    
}

@end
