//
//  UnselectableTagCollectionViewCell.swift
//  GAM
//
//  Created by Jungbin on 2023/08/01.
//

import UIKit
import SnapKit

final class UnselectableTagCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    let contentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.font = .caption2Regular
        label.textColor = .gamBlack
        return label
    }()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayout()
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Methods
    
    private func setLayout() {
        self.contentView.addSubviews([contentLabel])
        
        self.contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setUI() {
        self.contentView.backgroundColor = .gamWhite
        self.contentView.makeRounded(cornerRadius: 4)
    }
    
    func setData(data: String) {
        self.contentLabel.text = data
    }
}
