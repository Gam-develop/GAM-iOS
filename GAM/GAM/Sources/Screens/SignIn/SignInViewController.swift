//
//  SignInViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import UIKit
import SnapKit

final class SignInViewController: BaseViewController {
    
    // MARK: UIComponents
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: .gamLogoKorean)
        return imageView
    }()
    
    private let kakaoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.kakaoLoginMediumWide, for: .normal)
        return button
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.setLayout()
        self.setKakaoButtonAction()
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.view.backgroundColor = .gamBlack
    }
    
    private func setKakaoButtonAction() {
        self.kakaoButton.setAction { [weak self] in
            let signUpUsernameViewController: SignUpUsernameViewController = SignUpUsernameViewController()
            signUpUsernameViewController.modalPresentationStyle = .fullScreen
            self?.present(signUpUsernameViewController, animated: true)
        }
    }
}

// MARK: - UI

extension SignInViewController {
    private func setLayout() {
        self.view.addSubviews([logoImageView, kakaoButton])
        
        self.logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
            make.width.equalTo(110)
            make.height.equalTo(75.74)
        }
        
        self.kakaoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.logoImageView.snp.bottom).offset(300)
        }
    }
}
