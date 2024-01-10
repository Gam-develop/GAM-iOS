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
    case requestScrapDesigner(data: ScrapDesignerRequestDTO)
}

extension DesignerRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getPopularDesigner:
            return "/user/popular"
        case .requestScrapDesigner:
            return "/user/scrap"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPopularDesigner:
            return .get
        case .requestScrapDesigner:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPopularDesigner:
            return .requestPlain
        case .requestScrapDesigner(let data):
            let body: [String: Any] = [
                "targetUserId": data.targetUserId,
                "currentScrapStatus": data.currentScrapStatus
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getPopularDesigner, .requestScrapDesigner:
            return [
                "Content-Type": "application/json",
                "Authorization": UserInfo.shared.accessToken
            ]
        }
    }
}
