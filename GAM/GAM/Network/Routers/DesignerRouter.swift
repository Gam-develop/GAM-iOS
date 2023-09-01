//
//  DesignerRouter.swift
//  GAM
//
//  Created by Jungbin on 2023/08/24.
//

import Foundation
import Moya

enum DesignerRouter {
    case getPopularDesigner
}

extension DesignerRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getPopularDesigner:
            return "/user/popular"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPopularDesigner:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPopularDesigner:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getPopularDesigner:
            return [
                "Content-Type": "application/json",
                "Authorization": UserInfo.shared.accessToken
            ]
        }
    }
}
