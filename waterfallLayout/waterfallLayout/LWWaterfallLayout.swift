//
//  LWWaterfallLayout.swift
//  waterfallLayout
//
//  Created by liuwei on 2019/6/17.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

protocol LWWaterfallLayoutDelegate : class {
    func waterfallLayout(waterfallLayout: LWWaterfallLayout, heightWithItemIndex index: Int) -> CGFloat
}

class LWWaterfallLayout: UICollectionViewFlowLayout {
    
    var cols : CGFloat = 2
    weak var delegate : LWWaterfallLayoutDelegate?
    
    private lazy var attrs : [UICollectionViewLayoutAttributes] = {
        
        var attrs = [UICollectionViewLayoutAttributes]()
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - (cols - 1) * minimumInteritemSpacing) / cols
        
        for i in 0..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            guard let itemH : CGFloat = delegate?.waterfallLayout(waterfallLayout: self, heightWithItemIndex: i) else {
                fatalError("请实现对应数据源方法 返回cell的高度")
            }
            
            let minY = totalHeights.min()!
            let minYIndex = totalHeights.firstIndex(of: minY)!
            
            let itemX = sectionInset.left + CGFloat(minYIndex) * (itemW + minimumInteritemSpacing)
            let itemY = minY + minimumLineSpacing
            
            attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
            
            attrs.append(attr)
            
            totalHeights[minYIndex] += itemH + minimumLineSpacing
        }
        return attrs
    }()
    
    private lazy var totalHeights = Array(repeating: self.sectionInset.top, count: Int(self.cols))
    
    override func prepare() {
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrs
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: totalHeights.max()! + sectionInset.bottom)
    }
}
