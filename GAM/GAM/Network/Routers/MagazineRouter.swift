//
//  MagazineRouter.swift
//  GAM
//
//  Created by Jungbin on 2023/08/24.
//

import Foundation
import Moya

enum MagazineRouter {
    case getPopularMagazine
}

extension MagazineRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getPopularMagazine:
            return "/magazine/popular"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPopularMagazine:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPopularMagazine:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getPopularMagazine:
            return [
                "Content-Type": "application/json",
                "Authorization": UserInfo.shared.accessToken
            ]
        }
    }
}
