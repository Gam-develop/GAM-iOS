//
//  Environment.swift
//  GAM
//
//  Created by Jungbin on 2023/07/09.
//

import Foundation

enum Environment: String {
    case debug = "debug"
    case qa = "qa"
    case release = "release"
    
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let kakaoNativeAppKey = "KAKAO_NATIVE_APP_KEY"
            static let imageBaseURL = "IMAGE_BASE_URL"
        }
    }
    
    static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else { fatalError() }
        return dict
    }()
    
    static let BASE_URL: String = {
        guard let string = Environment.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("Base URL not set in plist for this environment")
        }
        return string
    }()
    
    static let KAKAO_NATIVE_APP_KEY: String = {
        guard let string = Environment.infoDictionary[Keys.Plist.kakaoNativeAppKey] as? String else {
            fatalError("KAKAO_NATIVE_APP_KEY not set in plist for this environment")
        }
        return string
    }()
    
    static let IMAGE_BASE_URL: String = {
        guard let string = Environment.infoDictionary[Keys.Plist.imageBaseURL] as? String else {
            fatalError("Image Base URL not set in plist for this environment")
        }
        return string
    }()
}

func env() -> Environment {
    #if DEBUG
    return .debug
    #elseif QA
    return .qa
    #elseif RELEASE
    return .release
    #endif
}
