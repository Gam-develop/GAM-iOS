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
    case checkUsernameDuplicated(data: String)
}

extension UserRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .requestSignUp:
            return "/user/onboard"
        case .checkUsernameDuplicated:
            return "/user/name/check"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestSignUp:
            return .post
        case .checkUsernameDuplicated:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .requestSignUp(let data):
            let body: [String: Any] = [
                "tags": data.tags,
                "userName": data.username,
                "info": data.info
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        case .checkUsernameDuplicated(let data):
            let body: [String: Any] = [
                "userName": data
            ]
            return .requestParameters(parameters: body, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .requestSignUp:
            return [
                "Content-Type": "application/json",
                "Authorization": UserInfo.shared.accessToken
            ]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
