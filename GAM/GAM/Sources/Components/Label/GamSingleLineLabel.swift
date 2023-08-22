//
//  GamSingleLineLabel.swift
//  GAM
//
//  Created by Jungbin on 2023/07/25.
//

import UIKit

class GamSingleLineLabel: UILabel {
    
    // MARK: Initializer
    
    init(text: String, font: UIFont, color: UIColor = .gamBlack) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = font
        self.textColor = color
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.sizeToFit()
    }
}
