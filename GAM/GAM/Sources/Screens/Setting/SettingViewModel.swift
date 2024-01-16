//
//  SettingViewModel.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/16/24.
//

import Foundation
import RxSwift


class SettingViewModel {
    
    // MARK: Properties
    
    private let networkService: MypageService
    private let disposeBag = DisposeBag()
    
    private let menus: [[String: [String]]] = [["문의 및 피드백": ["문의하기", "리뷰 남기기"]],
                                       ["앱 정보": ["서비스 소개", "만든 사람들", "버전 정보"]],
                                       ["약관 및 정책": ["서비스 이용약관", "개인정보처리방침"]],
                                       ["계정정보": ["로그아웃", "탈퇴하기"]]]
    var categories: [String] {
        return menus.flatMap { dictionary in
            return dictionary.keys
        }
    }
    var submenus: [[String]] {
        return menus.flatMap { dictionary in
            return dictionary.values
        }
    }

    // MARK: Life Cycle
    
    init(networkService: MypageService = MypageService.shared) {
        self.networkService = networkService
    }
}

// MARK: - Network
extension SettingViewModel {
    
}
