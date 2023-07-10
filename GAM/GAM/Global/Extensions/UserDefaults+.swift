//
//  UserDefaults+.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import Foundation

extension UserDefaults {
    
    /// UserDefaults key value가 많아지면 관리하기 어려워지므로 enum 'Keys'로 묶어 관리합니다.
    enum Keys: String {
        case userID = "userID"
        case recentSearch = "recentSearch"
    }
}
