//
//  SettingViewModel.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/16/24.
//

import Foundation
import RxSwift


final class SettingViewModel {
    
    // MARK: Properties
    
    private let networkService: AuthService
    private let disposeBag = DisposeBag()
    
    private let menus: [[String: [String]]] = [["문의 및 피드백": ["문의하기", "리뷰 남기기"]],
                                       ["앱 정보": ["서비스 소개", "만든 사람들", "버전 정보"]],
                                       ["약관 및 정책": ["서비스 이용약관", "개인정보처리방침"]],
                                       ["계정정보": ["로그아웃", "탈퇴하기"]]]
    lazy var categories: [String] = {
        return menus.flatMap { dictionary in
            return dictionary.keys
        }
    }()
    lazy var submenus: [[String]] = {
        return menus.flatMap { dictionary in
            return dictionary.values
        }
    }()
    
    struct Action {
        let logout = PublishSubject<Void>()
        let deleteAccount = PublishSubject<Void>()
        let showNetworkErrorAlert = PublishSubject<Void>()
        let popViewController = PublishSubject<Void>()
    }

    let action = Action()

    // MARK: Life Cycle
    
    init(networkService: AuthService = AuthService.shared) {
        self.networkService = networkService
        self.setBinding()
    }
    
    // MARK: Methods
    
    private func setBinding() {
        self.action.logout
            .subscribe(onNext: { [weak self] in
//                self?.logout()
                print("로그아웃됨")
            })
            .disposed(by: disposeBag)
    }
    
    func deleteAccount() {
        
    }
}

// MARK: - Network

extension SettingViewModel {
    private func logout() {
        networkService.requestLogout(data: LogoutRequestDTO(accessToken: UserInfo.shared.accessToken, refreshToken: UserInfo.shared.accessToken)) { networkResult in
            switch networkResult {
            case .success(_):
                break
            default:
                self.action.showNetworkErrorAlert.onNext(())
            }
        }
    }
}
