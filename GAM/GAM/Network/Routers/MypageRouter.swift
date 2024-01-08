//
//  MypageRouter.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/8/24.
//

import Foundation
import Moya

enum MypageRouter {
    case getPortfolio
}

extension MypageRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getPortfolio:
            return "/user/my/portfolio"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPortfolio:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPortfolio:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getPortfolio:
            return [
                "Content-Type": "application/json",
                "Authorization": UserInfo.shared.accessToken
            ]
        }
    }
}
