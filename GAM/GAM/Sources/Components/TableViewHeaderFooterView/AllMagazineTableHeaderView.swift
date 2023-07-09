//
//  AllMagazineTableHeaderView.swift
//  GAM
//
//  Created by Jungbin on 2023/07/10.
//

import UIKit
import SnapKit

final class AllMagazineTableHeaderView: UITableViewHeaderFooterView {
    
    // MARK: UIComponents
    
    private let thumbnailImageView: UIImageView = UIImageView(image: .defaultImageBlack)
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.setTextWithStyle(to: "영감 매거진 👀", style: .headline1SemiBold, color: .gamBlack)
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
        self.backgroundView?.backgroundColor = .clear
    }
    
    private func setLayout() {
        self.addSubviews([titleLabel])
        
        self.titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(11)
            make.left.right.equalToSuperview().inset(22)
        }
    }
}
