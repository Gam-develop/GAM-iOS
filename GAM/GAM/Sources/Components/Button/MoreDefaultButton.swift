//
//  MoreDefaultButton.swift
//  GAM
//
//  Created by Jungbin on 2023/07/26.
//

import UIKit

final class MoreDefaultButton: UIButton {
    
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
        self.setImage(.icnMoreDefault, for: .normal)
    }
}
