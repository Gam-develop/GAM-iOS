//
//  GamEmptyView.swift
//  GAM
//
//  Created by Jungbin on 2023/08/02.
//

import UIKit

final class GamEmptyView: UIView {
    
    enum EmptyType {
        case myProject
        case userProject
        case noSearchResult
    }
    
    private enum Text {
        static let addProject = "추가하러 가기"
        static let addProjectInfo = "프로젝트와 링크를 추가해\n나를 풍부하게 꾸며 보세요!"
        static let noUserProjectInfo = "등록된 프로젝트가 없습니다."
        static let noSearchResult = "검색 결과가 없어요\n다양한 검색으로 감을 찾아보세요"
    }
    
    // MARK: UIComponents
    
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
        case .myProject:
            self.button.setTitle(Text.addProject, for: .normal)
            self.infoLabel.text = Text.addProjectInfo
        case .userProject:
            self.infoLabel.text = Text.noUserProjectInfo
        case .noSearchResult:
            self.infoLabel.text = Text.noSearchResult
        }
    }
    
    private func setLayout(type: EmptyType) {
        self.addSubviews([infoLabel])
        
        self.infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        switch type {
        case .myProject:
            self.addSubview(button)
            
            self.button.snp.makeConstraints { make in
                make.top.equalTo(self.infoLabel.snp.bottom).offset(16)
                make.centerX.equalToSuperview()
                make.height.equalTo(37)
                make.width.equalTo(108)
            }
        case .userProject: break
        case .noSearchResult: break
        }
    }
}
