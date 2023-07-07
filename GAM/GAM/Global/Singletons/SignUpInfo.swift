//
//  SignUpInfo.swift
//  GAM
//
//  Created by Jungbin on 2023/07/07.
//

import Foundation

final class SignUpInfo {
    static var shared = SignUpInfo()
    
    init() { }
    
    var username: String?
    var tags: [Int]?
    var info: String?
}
