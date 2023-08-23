//
//  SignUpInfoViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/07/07.
//

import UIKit
import SnapKit
import RxSwift

final class SignUpInfoViewController: BaseViewController {
    
    enum Text {
        static let done = "감 잡으러 가기"
        static let wrongUsername = "한글, 영문, 숫자만 입력 가능합니다."
    }
    
    // MARK: UIComponents
    
    private let progressBarView: GamProgressBarView = GamProgressBarView()
    private let navigationView: GamNavigationView = GamNavigationView(type: .back)
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
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
        label.text = "0/20"
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
    
    // MARK: UIComponents
    
    private var keyboardHeight: CGFloat = 0
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setUI()
        self.setUsername()
        self.progressBarView.setProgress(step: .first)
        self.setTextField()
        self.checkEnterInfoLimit()
        self.setDoneButtonAction()
        self.setBackButtonAction(self.navigationView.backButton)
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
    
    private func setUsername() {
        self.questionLabel.text = "\(SignUpInfo.shared.username ?? "")님,\n\n감각적으로\n나를 표현해 보겠는감?"
        self.questionLabel.sizeToFit()
    }
    
    private func setTextField() {
        self.textField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                self.countLabel.text = "\(changedText.count)/20"
                if changedText.count > 0 {
                    let regex = "[가-힣ㄱ-ㅎㅏ-ㅣA-Za-z0-9\\s]{0,20}"
                    if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: changedText) && changedText.trimmingCharacters(in: .whitespaces).count >= 1 {
                        self.textField.setUnderlineColor(isCorrect: true)
                        self.infoLabel.isHidden = true
                        self.doneButton.isEnabled = true
                        SignUpInfo.shared.info = changedText
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
    
    private func checkEnterInfoLimit() {
        self.textField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { changedText in
                if changedText.count > 20 {
                    let index = changedText.index(changedText.startIndex, offsetBy: 20)
                    self.textField.text = String(changedText[..<index])
                    self.textField.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setDoneButtonAction() {
        self.doneButton.setAction { [weak self] in
            SignUpInfo.shared.info = self?.textField.text
            
            guard let tags = SignUpInfo.shared.tags,
               let username = SignUpInfo.shared.username,
               let info = SignUpInfo.shared.info
            else { return }
            
            let signUpData: SignUpRequestDTO = .init(
                tags: tags,
                username: username,
                info: info
            )
            
            self?.requestSignUp(data: signUpData, completion: {
                self?.present(GamTabBarController(), animated: true)
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

extension SignUpInfoViewController {
    private func requestSignUp(data: SignUpRequestDTO, completion: @escaping () -> ()) {
        self.startActivityIndicator()
        UserService.shared.requestSignUp(data: data) { networkResult in
            switch networkResult {
            case .success:
                completion()
            default:
                self.showNetworkErrorAlert()
            }
            self.stopActivityIndicator()
        }
    }
}

// MARK: - UI

extension SignUpInfoViewController {
    private func setLayout() {
        self.view.addSubviews([progressBarView, navigationView, questionLabel, textField, infoLabel, countLabel, doneButton])
        
        self.progressBarView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(14)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        self.navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.progressBarView.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview()
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
            make.top.equalTo(self.textField.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(20)
        }
        
        self.doneButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(42)
            make.height.equalTo(48)
        }
    }
}
