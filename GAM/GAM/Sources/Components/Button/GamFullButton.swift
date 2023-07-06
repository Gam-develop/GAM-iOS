//
//  GamFullButton.swift
//  GAM
//
//  Created by Jungbin on 2023/07/04.
//

import UIKit

final class GamFullButton: UIButton {
    
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
        self.setBackgroundColor(.gamBlack, for: .normal)
        self.setBackgroundColor(.gamGray1, for: .disabled)
        self.setTitleColor(.gamWhite, for: .normal)
        self.setTitleColor(.gamGray2, for: .disabled)
        
        self.makeRounded(cornerRadius: 5)
    }
}
