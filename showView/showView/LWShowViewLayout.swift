//
//  LWShowViewLayout.swift
//  showView
//
//  Created by liuwei on 2019/6/14.
//  Copyright © 2019 liuwei. All rights reserved.
//

import UIKit

class LWShowViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
       
        guard let attrs = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        print("attrs.count \(attrs.count)")

        let centerX = self.collectionView!.contentOffset.x + self.collectionView!.frame.size.width * 0.5
        
        for attr in attrs {
            //let attr = attrs.copy
            let offsetX : CGFloat = CGFloat(fabsf(Float(centerX - attr.center.x)))
            let scaleNum = 1 - offsetX / self.collectionView!.frame.size.width * 0.5
            attr.transform = CGAffineTransform(scaleX: scaleNum, y: scaleNum)
        }
        
        return attrs
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let rect = CGRect(origin: proposedContentOffset, size: self.collectionView!.frame.size)
        guard let attrs = super.layoutAttributesForElements(in: rect) else {
            return proposedContentOffset
        }

        let centerX = proposedContentOffset.x + self.collectionView!.frame.size.width * 0.5
        var minOffset: CGFloat = CGFloat(Int.max)
        for attr in attrs {
            if abs(minOffset) > abs(attr.center.x - centerX) {
                minOffset = attr.center.x - centerX
            }
        }

        return CGPoint(x: proposedContentOffset.x + minOffset, y: proposedContentOffset.y)
    }
    
}



