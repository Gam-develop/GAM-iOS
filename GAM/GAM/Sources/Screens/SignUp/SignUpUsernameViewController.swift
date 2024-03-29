//
//  SignUpUsernameViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/03.
//

import UIKit
import SnapKit
import RxSwift

final class SignUpUsernameViewController: BaseViewController {
    
    enum Text {
        static let question =
"""
당신의
닉네임은 무엇인감?
"""
        static let wrongUsername = "한글, 영문, 숫자만 입력 가능합니다."
        static let done = "입력 완료"
        static let duplicatedUsername = "이미 사용 중인 닉네임입니다."
    }
    
    // MARK: UIComponents
    
    private let progressBarView: GamProgressBarView = GamProgressBarView()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = Text.question
        label.font = .headline4Bold
        label.textColor = .gamBlack
        label.textAlignment = .left
        label.sizeToFit()
        return label
    }()
    
    private let textField: SignUpTextField = SignUpTextField()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = Text.wrongUsername
        label.font = .caption2Regular
        label.textColor = .gamRed
        label.textAlignment = .left
        label.sizeToFit()
        label.isHidden = true
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0/15"
        label.font = .caption2Regular
        label.textColor = .gamBlack
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    private let doneButton: GamFullButton = {
        let button: GamFullButton = GamFullButton(type: .system)
        button.setTitle(Text.done, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    // MARK: Properties
    
    private var keyboardHeight: CGFloat = 0
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setUI()
        self.progressBarView.setProgress(step: .first)
        self.setTextField()
        self.checkEnterNickNameLimit()
        self.setDoneButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardObserver(willShow: #selector(self.keyboardWillShow(_:)), willHide: #selector(self.keyboardWillHide(_:)))
        self.textField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.removeKeyboardObserver()
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.view.backgroundColor = .gamWhite
    }
    
    private func setTextField() {
        self.textField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                self.countLabel.text = "\(changedText.count)/15"
                self.infoLabel.text = Text.wrongUsername
                if changedText.count > 0 {
                    let regex = "[가-힣ㄱ-ㅎㅏ-ㅣA-Za-z0-9]{0,15}"
                    if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: changedText) && changedText.trimmingCharacters(in: .whitespaces).count >= 1 {
                        self.textField.setUnderlineColor(isCorrect: true)
                        self.infoLabel.isHidden = true
                        self.doneButton.isEnabled = true
                    } else {
                        self.textField.setUnderlineColor(isCorrect: false)
                        self.infoLabel.isHidden = false
                        self.doneButton.isEnabled = false
                    }
                } else {
                    self.textField.setUnderlineColor(isCorrect: true)
                    self.infoLabel.isHidden = true
                    self.doneButton.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func checkEnterNickNameLimit() {
        self.textField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { changedText in
                if changedText.count > 15 {
                    let index = changedText.index(changedText.startIndex, offsetBy: 15)
                    self.textField.text = String(changedText[..<index])
                    self.textField.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setDoneButtonAction() {
        self.doneButton.setAction { [weak self] in
            guard let username: String = self?.textField.text
            else { return }
            self?.checkUsernameDuplicated(username: username, completion: { isDuplicated in
                self?.infoLabel.isHidden = !isDuplicated
                self?.doneButton.isEnabled = !isDuplicated
                if isDuplicated {
                    self?.infoLabel.text = Text.duplicatedUsername
                } else {
                    SignUpInfo.shared.username = username
                    self?.navigationController?.pushViewController(SignUpTagViewController(), animated: true)
                }
            })
        }
    }
    
    @objc
    func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            self.doneButton.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(self.keyboardHeight + 16)
            }
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            self.doneButton.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(52)
            }
        }
    }
}

// MARK: - Network

extension SignUpUsernameViewController {
    private func checkUsernameDuplicated(username: String, completion: @escaping (Bool) -> ()) {
        self.startActivityIndicator()
        UserService.shared.checkUsernameDuplicated(data: username) { networkResult in
            switch networkResult {
            case .success(let responseData):
                if let result = responseData as? CheckUsernameDuplicatedResponseDTO {
                    completion(result.isDuplicated)
                }
            default:
                self.showNetworkErrorAlert()
            }
            self.stopActivityIndicator()
        }
    }
}

// MARK: - UI

extension SignUpUsernameViewController {
    private func setLayout() {
        self.view.addSubviews([progressBarView, questionLabel, textField, infoLabel, countLabel, doneButton])
        
        self.progressBarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(14)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        self.questionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.progressBarView.snp.bottom).offset(75)
            make.left.right.equalToSuperview().inset(20)
        }
        
        self.textField.snp.makeConstraints { make in
            make.top.equalTo(self.questionLabel.snp.bottom).offset(60)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        self.infoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.textField.snp.bottom).offset(8)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(21)
        }
        
        self.countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.infoLabel)
            make.right.equalToSuperview().inset(20)
        }
        
        self.doneButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(52)
            make.height.equalTo(48)
        }
    }
}
