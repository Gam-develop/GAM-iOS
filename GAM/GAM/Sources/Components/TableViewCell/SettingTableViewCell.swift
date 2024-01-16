//
//  SettingTableViewCell.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/16/24.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
    
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
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setConstraint()
    }
}

// MARK: - Custom Methods

extension SettingTableViewCell {
    
    func setMenuLable(_ label: String) {
        menuLabel.text = label
        
        if label == "버전 정보" {
            versionLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        }
    }
}

// MARK: - UI

extension SettingTableViewCell {
    
    private func setUI() {
        contentView.backgroundColor = .gamGray1
        contentView.addSubview(menuLabel)
        contentView.addSubview(versionLabel)
    }
    
    private func setConstraint() {
        menuLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }

        versionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
    }
}
