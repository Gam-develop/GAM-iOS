//
//  UserDefaultsManager.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import Foundation

struct UserDefaultsManager {
    static var userID: Int? {
        get { return UserDefaults.standard.integer(forKey: UserDefaults.Keys.userID.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.userID.rawValue) }
    }
    
    static var accessToken: String? {
        get { return UserDefaults.standard.string(forKey: UserDefaults.Keys.accessToken.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.accessToken.rawValue) }
    }
    
    static var refreshToken: String? {
        get { return UserDefaults.standard.string(forKey: UserDefaults.Keys.refreshToken.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.refreshToken.rawValue) }
    }
    
    static var fcmDeviceToken: String? {
        get { return UserDefaults.standard.string(forKey: UserDefaults.Keys.fcmDeviceToken.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.fcmDeviceToken.rawValue) }
    }
}
