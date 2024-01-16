//
//  SettingTableHeaderView.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/16/24.
//

import UIKit
import SnapKit

final class SettingTableHeaderView: UITableViewHeaderFooterView {
    
    // MARK: UIComponents

    private let categoryLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .body5Bold
        label.textColor = .gamGray3
        return label
    }()
    
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
    
    private func setUI() {
        self.backgroundView?.backgroundColor = .gamGray1
    }
    
    private func setLayout() {
        self.addSubviews([categoryLabel])

        self.categoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func setCategoryLabel(_ category: String) {
        categoryLabel.text = category
    }
}
