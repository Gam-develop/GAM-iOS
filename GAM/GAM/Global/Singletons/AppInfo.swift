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
    
    func currentAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
    
    func isUpdateNeeded(latest: String) -> Bool {
        let current: String = self.currentAppVersion()
        
        let latestFirst: Int = Int(latest.indexing(0)) ?? 0
        let currentFirst: Int = Int(current.indexing(0)) ?? 0
        
        let latestSeceond: Int = Int(latest.indexing(2)) ?? 0
        let currentSecond: Int = Int(current.indexing(2)) ?? 0
        
        return latestFirst > currentFirst || latestSeceond > currentSecond
    }
}
