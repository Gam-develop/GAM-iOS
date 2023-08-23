//
//  SignUpTextField.swift
//  GAM
//
//  Created by Jungbin on 2023/07/03.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class SignUpTextField: UITextField {
    
    enum Text {
        static let placeholder = "닉네임을 입력해 주세요."
    }
    
    // MARK: UIComponents
    
    private let clearButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setImage(.textFieldClear, for: .normal)
        return button
    }()
    
    private let underLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .gamBlack
        return view
    }()
    
    // MARK: Properties
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setPlaceholder()
        self.setClearButton()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.font = .body1Regular
        self.textColor = .gamBlack
        self.backgroundColor = .clear
        self.addRightPadding(30)
    }
    
    private func setPlaceholder() {
        self.setGamPlaceholder(Text.placeholder)
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
            }
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        self.addSubviews([clearButton, underLineView])
        
        self.clearButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(44)
        }
        
        self.underLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setUnderlineColor(isCorrect: Bool) {
        self.underLineView.backgroundColor = isCorrect ? .gamBlack : .gamRed
    }
}
