//
//  LeftAlignedCollectionViewFlowLayout.swift
//  GAM
//
//  Created by Jungbin on 2023/07/07.
//

import UIKit

final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 8
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 12
        self.minimumInteritemSpacing = 8
        self.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() as! UICollectionViewLayoutAttributes }
        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else { return }
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = 20.0
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}
