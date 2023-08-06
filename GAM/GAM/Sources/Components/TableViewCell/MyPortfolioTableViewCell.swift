//
//  MyPortfolioTableViewCell.swift
//  GAM
//
//  Created by Jungbin on 2023/08/02.
//

import UIKit
import SnapKit

final class MyPortfolioTableViewCell: PortfolioTableViewCell {
    
    // MARK: UIComponents
    
    let moreButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setImage(.icnCircleMore, for: .normal)
        return button
    }()
    
    // MARK: Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setLayout() {
        self.contentView.addSubview(moreButton)
        
        self.moreButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(4)
            make.width.height.equalTo(44)
        }
    }
}
