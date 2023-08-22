//
//  GamSearchTextField.swift
//  GAM
//
//  Created by Jungbin on 2023/07/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class GamSearchTextField: UITextField {
    
    enum Text {
        static let placeholder = "검색 플레이스홀더 있으면 좋음"
    }
    
    // MARK: UIComponents
    
    private let leadingView: UIView = UIView(frame: CGRect(x: 4, y: 0, width: 46, height: 44))
    
    private let searchImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(image: .icnSearch)
        imageView.frame = CGRect(x: 4, y: 0, width: 44, height: 44)
        return imageView
    }()
    
    let clearButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setImage((.textFieldClear), for: .normal)
        button.isHidden = true
        return button
    }()
    
    // MARK: Properties
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
        self.setClearButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setClearButton() {
        self.clearButton.rx.tap
            .bind {
                self.text = ""
                self.clearButton.isHidden = true
            }
            .disposed(by: self.disposeBag)
        
        self.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                self.clearButton.isHidden = changedText != "" ? false : true
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension GamSearchTextField {
    private func setUI() {
        self.backgroundColor = .gamWhite
        self.makeRounded(cornerRadius: 8)
        self.setGamPlaceholder(Text.placeholder)
        self.font = .body2Medium
        self.leftViewMode = .always
        self.tintColor = .gamBlack
        self.returnKeyType = .search
        self.addRightPadding(44)
    }
    
    private func setLayout() {
        self.leadingView.addSubview(searchImageView)
        self.leftView = self.leadingView
        self.addSubview(clearButton)
        
        self.clearButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(self.clearButton.snp.height)
        }
    }
}
