//
//  RecentSearchTableViewCell.swift
//  GAM
//
//  Created by Jungbin on 2023/07/10.
//

import UIKit
import SnapKit

final class RecentSearchTableViewCell: UITableViewCell {
    
    // MARK: UIComponents
    
    private let titleLabel: UILabel = UILabel()
    
    let removeButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setImage(.icnSmallX, for: .normal)
        return button
    }()
    
    // MARK: Properties
    
    private var sizingWidth: CGFloat = 0.0
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let rightInset = self.contentView.frame.width - (self.sizingWidth + 82)
        self.contentView.frame = self.contentView.frame.inset(by: .init(top: 4, left: 20, bottom: 4, right: rightInset >= 20 ? rightInset : 20))
    }
    
    private func setUI() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .gamWhite
        self.contentView.makeRounded(cornerRadius: 36 / 2)
        self.selectionStyle = .none
    }
    
    func setData(data: RecentSearchEntity) {
        self.titleLabel.setTextWithStyle(to: data.title, style: .caption3Medium, color: .gamBlack)
        
        let sizingLabel: UILabel = UILabel()
        sizingLabel.setTextWithStyle(to: data.title, style: .caption3Medium, color: .gamBlack)
        sizingLabel.sizeToFit()
        
        self.sizingWidth = sizingLabel.frame.width
    }
}

extension RecentSearchTableViewCell {
    private func setLayout() {
        self.contentView.addSubviews([titleLabel, removeButton])
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        self.removeButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.left.equalTo(self.titleLabel.snp.right).offset(8)
            make.right.equalToSuperview().inset(6)
            make.width.height.equalTo(32)
        }
    }
}
