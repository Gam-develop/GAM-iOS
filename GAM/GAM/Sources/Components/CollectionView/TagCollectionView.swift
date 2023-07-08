//
//  TagCollectionView.swift
//  GAM
//
//  Created by Jungbin on 2023/07/07.
//

import UIKit

final class TagCollectionView: UICollectionView {
    
    // MARK: Initializer
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled = false
        self.allowsMultipleSelection = true
        self.layoutMargins = .zero
        self.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        self.register(cell: TagCollectionViewCell.self)
    }
}
