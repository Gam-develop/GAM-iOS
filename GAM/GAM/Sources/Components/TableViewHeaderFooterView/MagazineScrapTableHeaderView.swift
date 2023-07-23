//
//  MagazineScrapTableHeaderView.swift
//  GAM
//
//  Created by Jungbin on 2023/07/10.
//

import UIKit
import SnapKit

final class MagazineScrapTableHeaderView: UITableViewHeaderFooterView {
    
    // MARK: UIComponents
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.setTextWithStyle(to: "총 스크랩", style: .subhead3SemiBold, color: .gamBlack)
        return label
    }()
    
    private let scrapCountLabel: UILabel = UILabel()
    
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
    
    func setCount(count: Int) {
        self.scrapCountLabel.setTextWithStyle(to: "\(count)", style: .subhead3SemiBold, color: .gamRed)
    }
    
    private func setUI() {
        self.backgroundView?.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews([titleLabel, scrapCountLabel])
        
        self.titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(11)
            make.left.equalToSuperview().inset(20)
        }
        
        self.scrapCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.left.equalTo(self.titleLabel.snp.right).offset(8)
        }
    }
}
