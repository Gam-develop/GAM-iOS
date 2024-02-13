//
//  AuthRouter.swift
//  GAM
//
//  Created by Jungbin on 2023/08/23.
//

import Foundation
import Moya

enum SocialType: String {
    case apple = "APPLE"
    case kakao = "KAKAO"
}

enum AuthRouter {
    case requestSocialLogin(data: SocialLoginRequestDTO)
    case requestRefreshToken(data: RefreshTokenRequestDTO)
    case requestLogout(data: LogoutRequestDTO)
    case requestSecession(data: SecessionRequestDTO)
}

extension AuthRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .requestSocialLogin:
            return "/social/login"
        case .requestRefreshToken:
            return "/social/refresh"
        case .requestLogout:
            return "social/logout"
        case .requestSecession:
            return "/user/my/account"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestSocialLogin, .requestRefreshToken, .requestLogout:
            return .post
        case .requestSecession:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .requestSocialLogin(let data):
            let body: [String: Any] = [
                "token": data.token,
                "providerType": data.socialType,
                "deviceToken": data.deviceToken
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        case .requestRefreshToken(let data):
            return .requestJSONEncodable(data)
        case .requestLogout(let data):
            return .requestJSONEncodable(data)
        case .requestSecession(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .requestSecession:
            return [
                "Content-Type": "application/json",
                "Authorization": UserInfo.shared.accessToken
            ]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
