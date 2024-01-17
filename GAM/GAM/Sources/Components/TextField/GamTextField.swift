//
//  GamTextField.swift
//  GAM
//
//  Created by Jungbin on 2023/08/02.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class GamTextField: UITextField {
    
    enum TextFieldType {
        case url
        case email
        case projectTitle
    }
    
    // MARK: UIComponents
    
    let clearButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setImage(.textFieldClear, for: .normal)
        return button
    }()
    
    // MARK: Properties
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(type: TextFieldType) {
        super.init(frame: .zero)
        
        self.setUI()
        self.setClearButton()
        self.setLayout()
        switch type {
        case .url : self.checkValidURL()
        case .email: self.checkValidEmail()
        case .projectTitle: self.checkValidProjectTitle()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.backgroundColor = .gamWhite
        self.font = .caption2Regular
        self.textColor = .gamBlack
        self.addLeftPadding(16)
        self.addRightPadding(40)
        self.layer.borderColor = UIColor.gamRed.cgColor
        self.makeRounded(cornerRadius: 8)
    }
    
    private func checkValidURL() {
        self.rx.text
            .orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, changedText) in
                if changedText.count > 0 {
                    if changedText.verifyUrl() && changedText.trimmingCharacters(in: .whitespaces).count >= 1 {
                        self.layer.borderWidth = 0
                    } else {
                        self.layer.borderWidth = 1
                    }
                } else {
                    self.layer.borderWidth = 0
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func checkValidEmail() {
        if self.isEnabled {
            self.rx.text
                .orEmpty
                .distinctUntilChanged()
                .withUnretained(self)
                .subscribe(onNext: { (owner, changedText) in
                    self.text?.removeLastSpace()
                    if changedText.count > 0 {
                        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                        if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: changedText) && changedText.trimmingCharacters(in: .whitespaces).count >= 1 {
                            self.layer.borderWidth = 0
                        } else {
                            self.layer.borderWidth = 1
                        }
                    } else {
                        self.layer.borderWidth = 0
                    }
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    private func checkValidProjectTitle() {
        if self.isEnabled {
            self.rx.text
                .orEmpty
                .distinctUntilChanged()
                .withUnretained(self)
                .observe(on: MainScheduler.asyncInstance)
                .subscribe(onNext: { (owner, changedText) in
                    if changedText.count > 12 {
                        owner.deleteBackward()
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func setClearButton() {
        self.rx.text
            .orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, changedText) in
                owner.clearButton.isHidden = changedText.isEmpty
            })
            .disposed(by: disposeBag)
        
        self.clearButton.rx.tap
            .withUnretained(self)
            .bind { (owner, _) in
                owner.text = ""
                owner.clearButton.isHidden = true
                self.layer.borderWidth = 0
            }
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        self.addSubviews([clearButton])
        
        self.clearButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(2)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(44)
        }
    }
}
