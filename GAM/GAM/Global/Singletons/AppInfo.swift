//
//  AppInfo.swift
//  GAM
//
//  Created by Jungbin on 2023/08/23.
//

import Foundation

final class AppInfo {
    static var shared = AppInfo()
    
    init() { }
    
    var latestVersion: String = ""
    
    var url: GamURLEntity = .init(
        intro: "",
        privacyPolicy: "",
        agreement: "",
        makers: ""
    )
}
