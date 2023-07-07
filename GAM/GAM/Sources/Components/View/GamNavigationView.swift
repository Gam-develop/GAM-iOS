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
//        case backTitleShare
//        case backTitleSave
//        case search
//        case searchFilter
//        case profile
    }
    
    enum Text {
        static let saveText = "저장"
    }
    
    // MARK: Properties
    
//    private lazy var titleLabel: UILabel = {
//        let label: UILabel = UILabel()
//        label.font = .sb18
//        label.textColor = .sfBlack100
//        label.textAlignment = .center
//        return label
//    }()
//
//    private lazy var logoImageView: UIImageView = {
//        let imageView: UIImageView = UIImageView()
//        imageView.image = UIImage(named: Text.logoImageName)
//        return imageView
//    }()
    
    lazy var backButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setImage(.chevronLeft, for: .normal)
        return button
    }()
    
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
//
//    lazy var searchBarButton: UIButton = {
//        let button = SnapfitSearchBarButton(type: .system)
//        return button
//    }()
//
//    lazy var searchTextField: SnapfitSearchTextField = {
//        let textField: SnapfitSearchTextField = SnapfitSearchTextField()
//        textField.placeholder = "분위기, 작가 등을 검색해 보세요."
//        return textField
//    }()
//
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
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Methods
    
//    func setTitle(_ text: String) {
//        self.titleLabel.text = text
//    }
}

// MARK: - UI

extension GamNavigationView {
    private func setDefaultLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
//    private func setHomeLayout() {
//        self.addSubviews([logoImageView, notificationButton])
//
//        self.logoImageView.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview().inset(8)
//            make.leading.equalTo(22)
//            make.width.equalTo(108)
//        }
//
//        self.setRightButtonLayout(button: self.notificationButton)
//    }
//
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
    
    private func setBackLayout() {
        self.addSubviews([backButton])
        
        self.setLeftButtonLayout(button: self.backButton)
    }
    
//    private func setCloseLayout() {
//        self.addSubviews([closeButton])
//
//        self.setLeftButtonLayout(button: self.closeButton)
//    }
//
//    private func setBackLikeMoreLayout() {
//        self.addSubviews([backButton, moreButton, likeButton])
//
//        self.setLeftButtonLayout(button: self.backButton)
//        self.setRightButtonLayout(button: self.moreButton)
//
//        self.likeButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.trailing.equalTo(self.moreButton.snp.leading).offset(8)
//            make.width.height.equalTo(44)
//        }
//    }
//
//    private func backTitleMoreLayout() {
//        self.addSubviews([backButton, titleLabel, moreButton])
//
//        self.setLeftButtonLayout(button: self.backButton)
//        self.setTitleLabelLayout()
//        self.setRightButtonLayout(button: self.moreButton)
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
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(4)
            make.width.height.equalTo(44)
        }
    }
    
    private func setLeftButtonLayout(button: UIButton) {
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(4)
            make.width.height.equalTo(44)
        }
    }
    
//    private func setTitleLabelLayout() {
//        self.titleLabel.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.72266)
//        }
//    }
}
