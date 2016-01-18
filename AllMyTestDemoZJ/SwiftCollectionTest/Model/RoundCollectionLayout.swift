//
//  RoundCollectionLayout.swift
//  MoviePlayerTest
//
//  Created by zjhaha on 16/1/18.
//  Copyright © 2016年 zjhaha. All rights reserved.
//

import UIKit

class RoundCollectionLayout: UICollectionViewLayout {

    private var _cellCount:Int = 0
    private var _collectSize:CGSize?
    private var _center:CGPoint?
    private var _radius:CGFloat?
    private let ITEM_SIZE:CGFloat = 70.0
    private var insertIndexPaths = [NSIndexPath]()
    
    override func prepareLayout() {
        super.prepareLayout()
        
        _collectSize = self.collectionView?.frame.size
        _cellCount = (self.collectionView?.numberOfItemsInSection(0))!
        _center = CGPointMake((_collectSize?.width)!/2.0, (_collectSize?.height)!/2.0);
        _radius = min((_collectSize?.width)!,(_collectSize?.height)!)/2.5
    }
    
    /**
     内容区域的总大小
     */
    override func collectionViewContentSize() -> CGSize {
        return _collectSize!
    }
    
    /**
    *  可见区域
    */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArr = [UICollectionViewLayoutAttributes]()
        let count = self._cellCount
        for i in 0 ..< count {
            
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            let attributes = self.layoutAttributesForItemAtIndexPath(indexPath)
            attributesArr.append(attributes!)
        }
        return attributesArr
    }
    
    /**
    *  cell的排列
    */
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attrs.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE)
        let x = Double((_center?.x)!) + Double(_radius!) * cos(Double(2*indexPath.item)*M_PI/Double(_cellCount))
        let y = Double((_center?.y)!) + Double(_radius!) * sin(Double(2*indexPath.item)*M_PI/Double(_cellCount))
        attrs.center = CGPointMake(CGFloat(x), CGFloat(y))
        return attrs
    }
    
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        
        if self.insertIndexPaths.contains(itemIndexPath) {
            if let _ = attributes{
                attributes = self.layoutAttributesForItemAtIndexPath(itemIndexPath)
            }
            
            attributes?.alpha = 0.0
            attributes?.center = CGPointMake((_center?.x)! , (_center?.y)!)
        }
        return attributes
    }
    
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        
        super.prepareForCollectionViewUpdates(updateItems)
        self.insertIndexPaths = [NSIndexPath]()
        for update in updateItems {
            if update.updateAction == UICollectionUpdateAction.Insert{
                self.insertIndexPaths.append(update.indexPathAfterUpdate!)
            }
        }
     }
    
}