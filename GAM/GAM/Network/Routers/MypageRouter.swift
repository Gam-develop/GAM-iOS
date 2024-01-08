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
    case setRepPortfolio(data: SetRepRequestDTO)
}

extension MypageRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getPortfolio:
            return "/user/my/portfolio"
        case .setRepPortfolio:
            return "/work/main"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPortfolio:
            return .get
        case .setRepPortfolio:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .getPortfolio:
            return .requestPlain
        case .setRepPortfolio(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    
    var headers: [String: String]? {
        switch self {
        case .getPortfolio, .setRepPortfolio:
            return [
                "Content-Type": "application/json",
                "Authorization": UserInfo.shared.accessToken
            ]
        }
    }
}
