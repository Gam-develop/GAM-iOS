//
//  GamEmptyView.swift
//  GAM
//
//  Created by Jungbin on 2023/08/02.
//

import UIKit

final class GamEmptyView: UIView {
    
    enum EmptyType {
        case project
    }
    
    private enum Text {
        static let addProject = "추가하러 가기"
        static let addProjectInfo = "프로젝트와 링크를 추가해\n나를 풍부하게 꾸며보세요!"
    }
    
    // MARK: UIComponents
    
    private let emptyImageView: UIImageView = UIImageView(image: .imgEmpty)
    
    private let infoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .caption3Medium
        label.textColor = .gamGray3
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let button: GamRoundedButton = {
        let button: GamRoundedButton = GamRoundedButton(type: .system)
        return button
    }()
    
    // MARK: Properties
    
    // MARK: Initializer
    
    init(type: EmptyType) {
        super.init(frame: .zero)
        
        self.setUI(type: type)
        self.setLayout(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI(type: EmptyType) {
        self.isHidden = true
        
        switch type {
        case .project:
            self.button.setTitle(Text.addProject, for: .normal)
            self.infoLabel.text = Text.addProjectInfo
        }
    }
    
    private func setLayout(type: EmptyType) {
        self.addSubviews([emptyImageView, infoLabel])
        
        self.emptyImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        self.infoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.emptyImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        switch type {
        case .project:
            self.addSubview(button)
            
            self.button.snp.makeConstraints { make in
                make.top.equalTo(self.infoLabel.snp.bottom).offset(16)
                make.centerX.equalToSuperview()
                make.height.equalTo(37)
                make.width.equalTo(108)
            }
        }
    }
}
