//
//  RepView.swift
//  GAM
//
//  Created by Jungbin on 2023/07/27.
//

import UIKit
import SnapKit

final class RepView: UIView {
    
    // MARK: UIComponents
    
    private let titleLabel: GamSingleLineLabel = GamSingleLineLabel(text: "대표", font: .caption3Medium, color: .gamWhite)
    
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
        self.backgroundColor = .gamBlack
        self.makeRounded(cornerRadius: 4)
    }
    
    private func setLayout() {
        self.addSubview(titleLabel)
        
        self.snp.makeConstraints { make in
            make.width.equalTo(57)
            make.height.equalTo(30)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
    }
}
