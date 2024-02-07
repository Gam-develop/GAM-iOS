//
//  SettingTableViewCell.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/16/24.
//

import UIKit
import SnapKit

final class SettingTableViewCell: UITableViewCell {
    
    // MARK: UI Component
    
    private let menuLabel: UILabel = {
        let label = UILabel()
        label.font = .body1Regular
        label.textColor = .gamBlack
        return label
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.font = .body1Regular
        label.textColor = .gamGray2
        return label
    }()
 
    // MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUI()
        self.setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setUI()
        self.setConstraint()
    }
}

// MARK: - Custom Methods

extension SettingTableViewCell {
    
    func setMenuLabel(_ label: String) {
        self.menuLabel.text = label
        
        if label == "버전 정보" {
            self.versionLabel.text = AppInfo.shared.currentAppVersion()
        }
    }
}

// MARK: - UI

extension SettingTableViewCell {
    
    private func setUI() {
        self.contentView.backgroundColor = .gamGray1
        self.contentView.addSubview(menuLabel)
        self.contentView.addSubview(versionLabel)
    }
    
    private func setConstraint() {
        self.menuLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }

        self.versionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
    }
}
