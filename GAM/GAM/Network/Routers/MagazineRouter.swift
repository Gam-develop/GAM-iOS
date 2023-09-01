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
    case getAllMagazine
}

extension MagazineRouter: TargetType {
    
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getPopularMagazine:
            return "/magazine/popular"
        case .getAllMagazine:
            return "/magazine"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPopularMagazine, .getAllMagazine:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPopularMagazine, .getAllMagazine:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getPopularMagazine, .getAllMagazine:
            return [
                "Content-Type": "application/json",
                "Authorization": UserInfo.shared.accessToken
            ]
        }
    }
}
