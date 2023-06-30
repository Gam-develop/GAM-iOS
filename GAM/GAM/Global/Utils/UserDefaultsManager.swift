//
//  UserDefaultsManager.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import Foundation

struct UserDefaultsManager {
    static var userID: Int? {
        get { return UserDefaults.standard.integer(forKey: UserDefaults.Keys.userID) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.userID) }
    }
}
