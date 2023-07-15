//
//  GamNavigationView.swift
//  GAM
//
//  Created by Jungbin on 2023/07/07.
//

import UIKit
import SnapKit

final class GamNavigationView: UIView {
    
    enum NavigationType {
        case back
        case backTitleShare
        case search
        case searchFilter
//        case backTitleSave
//        case profile
    }
    
    enum Text {
        static let saveText = "저장"
    }
    
    // MARK: Properties
    
    private lazy var centerTitleLabel: UILabel = UILabel()
    
    lazy var backButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setImage(.chevronLeft, for: .normal)
        return button
    }()
    
    lazy var shareButton: ShareButton = ShareButton(type: .system)
    lazy var searchButton: SearchButton = SearchButton(type: .system)
    lazy var filterButton: FilterButton = FilterButton(type: .system)
    
//    lazy var notificationButton: UIButton = {
//        let button: UIButton = UIButton(type: .system)
//        button.setImage(UIImage(named: Text.notificationButtonImageName), for: .normal)
//        return button
//    }()
//
//    lazy var closeButton: UIButton = {
//        let button: UIButton = UIButton(type: .system)
//        button.setImage(UIImage(named: Text.closeButtonImageName), for: .normal)
//        return button
//    }()
//
//    lazy var likeButton: UIButton = {
//        let button: UIButton = UIButton(type: .system)
//        button.setImage(UIImage(named: Text.likeButtonImageName), for: .normal)
//        return button
//    }()
//
//    lazy var moreButton: UIButton = {
//        let button: UIButton = UIButton(type: .system)
//        button.setImage(UIImage(named: Text.moreButtonIamgeName), for: .normal)
//        return button
//    }()
//    lazy var saveButton: UIButton = {
//        let button: UIButton = UIButton(type: .system)
//        button.setTitle(Text.saveText, for: .normal)
//        button.setTitleColor(.sfBlack100, for: .normal)
//        button.titleLabel?.font = .b16
//        return button
//    }()
    
    // MARK: Initializer
    
    init(type: NavigationType) {
        super.init(frame: .zero)
        
        self.setDefaultLayout()
        
        switch type {
        case .back: self.setBackLayout()
        case .backTitleShare: self.setBackTitleShareLayout()
        case .search: self.setSearchLayout()
        case .searchFilter: self.setSearchFilterLayout()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Methods
    
    func setCenterTitle(_ text: String) {
        self.centerTitleLabel.setTextWithStyle(to: text, style: .headline2SemiBold, color: .gamBlack)
        self.centerTitleLabel.textAlignment = .center
    }
}

// MARK: - UI

extension GamNavigationView {
    private func setDefaultLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
    }
    
    private func setBackLayout() {
        self.addSubviews([backButton])
        
        self.setLeftButtonLayout(button: self.backButton)
    }
    
    private func setBackTitleShareLayout() {
        self.addSubviews([backButton, centerTitleLabel, shareButton])
        
        self.setLeftButtonLayout(button: self.backButton)
        self.setRightButtonLayout(button: self.shareButton)
        self.setCenterTitleLabelLayout()
    }
    
    private func setSearchLayout() {
        self.addSubviews([searchButton])
        
        self.setRightButtonLayout(button: self.searchButton)
    }
    
    private func setSearchFilterLayout() {
        self.addSubviews([searchButton, filterButton])
        
        self.setRightButtonLayout(button: self.searchButton)
        self.filterButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.searchButton)
            make.width.height.equalTo(44)
            make.trailing.equalTo(self.searchButton.snp.leading)
        }
    }
    
//    private func setBackTitleLayout() {
//        self.addSubviews([backButton, titleLabel])
//
//        self.setLeftButtonLayout(button: self.backButton)
//        self.setTitleLabelLayout()
//    }
//
//    private func setBackSearchButtonLayout() {
//        self.addSubviews([backButton, searchBarButton])
//
//        self.setLeftButtonLayout(button: self.backButton)
//        self.searchBarButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(self.backButton.snp.right)
//            make.right.equalToSuperview().inset(8)
//            make.height.equalTo(40)
//        }
//    }
//
//    private func setBackSearchLayout() {
//        self.addSubviews([backButton, searchTextField])
//
//        self.setLeftButtonLayout(button: self.backButton)
//        self.searchTextField.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(self.backButton.snp.right)
//            make.right.equalToSuperview().inset(8)
//            make.height.equalTo(40)
//        }
//    }
    
//    private func setCloseLayout() {
//        self.addSubviews([closeButton])
//
//        self.setLeftButtonLayout(button: self.closeButton)
//    }
//
//    private func setCloseSaveLayout() {
//        self.addSubviews([closeButton, saveButton])
//
//        self.setLeftButtonLayout(button: self.closeButton)
//        self.setRightButtonLayout(button: self.saveButton)
//    }
//
//    private func setBackSaveLayout() {
//        self.addSubviews([backButton, saveButton])
//
//        self.setLeftButtonLayout(button: self.backButton)
//        self.setRightButtonLayout(button: self.saveButton)
//    }
    
    private func setRightButtonLayout(button: UIButton) {
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(4)
            make.width.height.equalTo(44)
        }
    }
    
    private func setLeftButtonLayout(button: UIButton) {
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(4)
            make.width.height.equalTo(44)
        }
    }
    
    private func setCenterTitleLabelLayout() {
        self.centerTitleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(6)
            make.centerX.equalToSuperview()
            make.height.equalTo(33)
            make.width.equalToSuperview().multipliedBy(0.68)
        }
    }
}
