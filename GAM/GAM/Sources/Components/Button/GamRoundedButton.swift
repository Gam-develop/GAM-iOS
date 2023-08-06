//
//  GamRoundedButton.swift
//  GAM
//
//  Created by Jungbin on 2023/08/02.
//

import UIKit

final class GamRoundedButton: UIButton {
    
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
        self.setTitleColor(.gamWhite, for: .normal)
        self.makeRounded(cornerRadius: 18.5)
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        
        self.titleLabel?.font = .caption3Medium
    }
}
