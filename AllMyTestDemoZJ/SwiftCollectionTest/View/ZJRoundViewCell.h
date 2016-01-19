//
//  ZJRoundViewCell.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/18.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *identifier = @"ZJRoundViewCell";

@interface ZJRoundViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView WithIndexPath:(NSIndexPath *)indexPath;
@end
