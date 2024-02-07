//
//  BrowseScrapCollectionViewCell.swift
//  GAM
//
//  Created by Jungbin on 2023/07/24.
//

import UIKit
import SnapKit

final class BrowseScrapCollectionViewCell: UICollectionViewCell {
    
    // MARK: UIComponents
    
    private let thumbnailImageView: UIImageView = UIImageView(image: .defaultImage)
    
    private let authorLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .body4Bold
        label.textColor = .gamBlack
        return label
    }()
    
    let scrapButton: ScrapButton = ScrapButton(type: .system)
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .gamWhite
        self.contentView.makeRounded(cornerRadius: 10)
    }
    
    func setData(data: BrowseDesignerScrapEntity) {
        self.thumbnailImageView.setImageUrl(data.thumbnailImageURL)
        self.authorLabel.text = data.name
        self.scrapButton.isSelected = data.isScrap
    }
}

// MARK: - UI

extension BrowseScrapCollectionViewCell {
    private func setLayout() {
        self.contentView.addSubviews([thumbnailImageView, scrapButton, authorLabel])
        
        self.thumbnailImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(self.thumbnailImageView.snp.width)
        }
        
        self.scrapButton.snp.makeConstraints { make in
            make.top.equalTo(self.thumbnailImageView.snp.bottom)
            make.right.equalToSuperview().inset(4)
            make.bottom.equalToSuperview()
            make.width.equalTo(self.scrapButton.snp.height)
        }
        
        self.authorLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.scrapButton)
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(24)
            make.right.equalTo(self.scrapButton.snp.left)
        }
    }
}
