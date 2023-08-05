//
//  PortfolioTableFooterView.swift
//  GAM
//
//  Created by Jungbin on 2023/07/30.
//

import UIKit
import SnapKit

final class PortfolioTableFooterView: UITableViewHeaderFooterView {
    
    // MARK: UIComponents
    
    private let titleLabel: GamSingleLineLabel = GamSingleLineLabel(text: "", font: .subhead4Bold)
    
    private let stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.spacing = 62.adjustedW
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let behanceButton: GamContactButton = GamContactButton(contactType: .behance)
    let instagramButton: GamContactButton = GamContactButton(contactType: .instagram)
    let notionButton: GamContactButton = GamContactButton(contactType: .notion)
    
    // MARK: Initializer
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    func setTitle(title: String) {
        self.titleLabel.text = title
    }
    
    func setButtonState(behance: String, instagram: String, notion: String) {
        self.behanceButton.isSelected = behance.isEmpty
        self.instagramButton.isSelected = instagram.isEmpty
        self.notionButton.isSelected = notion.isEmpty
    }
    
    private func setUI() {
        self.backgroundView?.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews([titleLabel, stackView])
        self.stackView.addArrangedSubviews([behanceButton, instagramButton, notionButton])
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(42)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(27)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
            make.height.equalTo(60)
        }
        
        self.behanceButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        self.instagramButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        self.notionButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
    }
}
