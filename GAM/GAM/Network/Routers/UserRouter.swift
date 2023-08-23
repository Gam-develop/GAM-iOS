//
//  UserRouter.swift
//  GAM
//
//  Created by Jungbin on 2023/08/23.
//

import Foundation
import Moya

enum UserRouter {
    case requestSignUp(data: SignUpRequestDTO)
}

extension UserRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .requestSignUp:
            return "/user/onboard"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestSignUp:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .requestSignUp(let data):
            let body: [String: Any] = [
                "tag": data.tags,
                "userName": data.username,
                "info": data.info
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .requestSignUp:
            return ["accessToken": UserInfo.shared.accessToken]
//        default:
//            return ["Content-Type": "application/json"]
        }
    }
}
