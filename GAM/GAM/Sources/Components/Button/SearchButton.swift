//
//  SearchButton.swift
//  GAM
//
//  Created by Jungbin on 2023/07/09.
//

import UIKit

final class SearchButton: UIButton {
    
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
        self.setImage(.icnSearch, for: .normal)
    }
}
