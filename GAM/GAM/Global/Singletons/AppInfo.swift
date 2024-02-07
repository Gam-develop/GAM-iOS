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
    
    var url: GamURLEntity = .init(
        intro: "",
        privacyPolicy: "",
        agreement: "",
        makers: ""
    )
    
    let appID: String = "6477517719"
    
}
