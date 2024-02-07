//
//  SplashViewController.swift
//  GAM
//
//  Created by Jungbin on 1/10/24.
//

import UIKit
import SnapKit

final class SplashViewController: BaseViewController {
    
    // MARK: UIComponents
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: .gamLogoKorean)
        return imageView
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.setLayout()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.autoSignIn()
        }
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.view.backgroundColor = .gamBlackLogo
    }
    
    private func autoSignIn() {
        // TODO: FCM
//        let deviceToken: String = UserInfo.shared.deviceToken
        
        let tokenData: RefreshTokenRequestDTO = .init(
            accessToken: UserDefaultsManager.accessToken ?? "",
            refreshToken: UserDefaultsManager.refreshToken ?? ""
        )
        
        self.requestRefreshToken(data: tokenData) { isProfileCompleted in
            self.presentNextViewController(isProfileCompleted: isProfileCompleted)
        }
    }
    
    private func presentNextViewController(isProfileCompleted: Bool) {
        if isProfileCompleted {
            self.present(GamTabBarController(), animated: true)
        } else {
            self.present(BaseNavigationController(rootViewController: SignUpUsernameViewController()), animated: true)
        }
    }
}

// MARK: - UI

extension SplashViewController {
    private func setLayout() {
        self.view.addSubviews([logoImageView])
        
        self.logoImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(110)
            make.height.equalTo(75.74)
        }
    }
}
