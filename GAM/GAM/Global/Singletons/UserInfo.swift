//
//  UserInfo.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import Foundation

final class UserInfo {
    static var shared = UserInfo()
    
    init() { }
    
    var userID: Int?
}
