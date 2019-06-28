//
//  LWPageCollectionViewLayout.swift
//  LWLivePlay
//
//  Created by liuwei on 2019/6/28.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

class LWPageCollectionViewLayout: UICollectionViewFlowLayout {
    
    var cols : Int = 3
    var rows : Int = 2
    
    private var pageItemNum : Int { //每一个页面的item的个数
        return cols * rows
    }
    
    var maxWidth : CGFloat = 0
    
    private lazy var attrs : [UICollectionViewLayoutAttributes] = {
        var attrs = [UICollectionViewLayoutAttributes]()
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(rows - 1) * minimumLineSpacing) / CGFloat(rows)
        
        let sectionCount = collectionView!.numberOfSections
        
        // 记录之前section的page和
        var prePageCount = 0
        
        for i in 0..<sectionCount {
            let itemCount = collectionView!.numberOfItems(inSection: i)
            
            for j in 0..<itemCount {
                let page = j / (cols * rows)
                let index = j % (cols * rows)
                
                let itemX : CGFloat = CGFloat(prePageCount + page) * collectionView!.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(index % cols)
                let itemY : CGFloat = sectionInset.top + CGFloat(index / cols) * (itemH + minimumLineSpacing)
                
                let indexPath = IndexPath(item: j, section: i)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                attrs.append(attr)
            }
            prePageCount += (itemCount - 1) / pageItemNum + 1
            
        }
        maxWidth = CGFloat(prePageCount) * collectionView!.bounds.width
        return attrs
    } ()
    
//    override func prepare() {
//        super.prepare()
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrs
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxWidth, height: 0)
    }
    
}
