//
//  FilterButton.swift
//  GAM
//
//  Created by Jungbin on 2023/07/14.
//

import UIKit

final class FilterButton: UIButton {
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.tintColor = .clear
        self.setImage(.icnFilterBlack, for: .selected)
        self.setImage(.icnFilterGray, for: .normal)
    }
}
