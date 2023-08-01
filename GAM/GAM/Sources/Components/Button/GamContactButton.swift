//
//  GamContactButton.swift
//  GAM
//
//  Created by Jungbin on 2023/08/01.
//

import UIKit

final class GamContactButton: UIButton {
    
    enum ContactType {
        case behance
        case instagram
        case notion
        case email
    }
    
    // MARK: Initializer
    
    init(contactType: ContactType) {
        super.init(frame: .zero)
        
        self.setUI(contactType: contactType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI(contactType: ContactType) {
        switch contactType {
        case .behance:
            self.setImage(.behanceOn, for: .normal)
            self.setImage(.behanceOff, for: .disabled)
        case .instagram:
            self.setImage(.instagramOn, for: .normal)
            self.setImage(.instagramOff, for: .disabled)
        case .notion:
            self.setImage(.notionOn, for: .normal)
            self.setImage(.notionOff, for: .disabled)
        case .email:
            self.setImage(.emailOn, for: .normal)
            self.setImage(.emailOff, for: .disabled)
        }
    }
}
