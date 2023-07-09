//
//  ScrapButton.swift
//  GAM
//
//  Created by Jungbin on 2023/07/09.
//

import UIKit
import SnapKit

final class ScrapButton: UIButton {
    
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
        self.setImage(.scrapOff, for: .normal)
        self.setImage(.scrapOn, for: .selected)
        
        self.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
    }
}
