//
//  GamStarLabel.swift
//  GAM
//
//  Created by Jungbin on 2023/08/07.
//

import UIKit
import SnapKit

class GamStarLabel: GamSingleLineLabel {
    
    // MARK: UIComponenets
    
    private lazy var starLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "*"
        label.textColor = .gamRed
        label.font = .subhead4Bold
        return label
    }()
    
    // MARK: Initializer
    
    override init(text: String, font: UIFont, color: UIColor = .gamBlack) {
        super.init(text: text, font: font, color: color)
        self.setDefaultLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI

extension GamStarLabel {
    private func setDefaultLayout() {
        self.addSubview(starLabel)
        
        self.starLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(self.snp.trailing).offset(3.47)
            make.width.equalTo(10)
            make.height.equalTo(27)
        }
    }
}
