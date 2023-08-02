//
//  AddPortfolioTableViewCell.swift
//  GAM
//
//  Created by Jungbin on 2023/08/02.
//

import UIKit
import SnapKit

final class AddPortfolioTableViewCell: UITableViewCell {
    
    // MARK: UIComponents
    
    let addProjectButton: GamFullButton = {
        let button: GamFullButton = GamFullButton(type: .system)
        button.setTitle("프로젝트 추가하기", for: .normal)
        return button
    }()
    
    // MARK: Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.contentView.addSubviews([self.addProjectButton])
        
        self.addProjectButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }
}
