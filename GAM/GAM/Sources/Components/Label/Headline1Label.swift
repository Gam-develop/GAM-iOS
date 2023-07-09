//
//  Headline1Label.swift
//  GAM
//
//  Created by Jungbin on 2023/07/09.
//

import UIKit

final class Headline1Label: UILabel {
    
    // MARK: Initializer
    
    init(text: String) {
        super.init(frame: .zero)
        
        self.text = text
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.font = .headline1SemiBold
        self.textColor = .gamBlack
        self.sizeToFit()
    }
}
