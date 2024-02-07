//
//  RecentMagazineTableHeaderView.swift
//  GAM
//
//  Created by Jungbin on 2023/07/09.
//

import UIKit
import SnapKit

final class RecentMagazineTableHeaderView: UITableViewHeaderFooterView {
    
    // MARK: UIComponents
    
    private let thumbnailImageView: UIImageView = UIImageView(image: .defaultImage)
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 3
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .caption3Medium
        label.textColor = .gamWhite
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
    
    func setData(data: MagazineEntity) {
        self.thumbnailImageView.setImageUrl(data.thumbnailImageURL)
        self.titleLabel.setTextWithStyle(to: data.title, style: .headline3Medium, color: .gamWhite)
        self.authorLabel.text = data.author
    }
}

extension RecentMagazineTableHeaderView {
    private func setLayout() {
        self.addSubviews([thumbnailImageView, authorLabel, titleLabel])
        
        self.thumbnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.authorLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.authorLabel.snp.top).offset(-12)
            make.left.right.equalToSuperview().inset(20)
        }
    }
}
