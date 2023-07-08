//
//  TagCollectionViewCell.swift
//  GAM
//
//  Created by Jungbin on 2023/07/07.
//

import UIKit
import SnapKit

final class TagCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    let contentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.font = .caption2Regular
        label.textColor = .gamBlack
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = .gamBlack
                contentLabel.textColor = .gamWhite
            } else {
                contentView.backgroundColor = .gamWhite
                contentLabel.textColor = .gamBlack
            }
        }
    }
    
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
        self.contentView.backgroundColor = .clear
        self.contentView.makeRounded(cornerRadius: 4)
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.gamBlack.cgColor
    }
    
    func setData(data: String) {
        self.contentLabel.text = data
    }
}
