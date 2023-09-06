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
    case getScrapMagazine
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
        case .getScrapMagazine:
            return "/magazine/scraps"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPopularMagazine, .getAllMagazine, .getScrapMagazine:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getPopularMagazine, .getAllMagazine, .getScrapMagazine:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getPopularMagazine, .getAllMagazine, .getScrapMagazine:
            return [
                "Content-Type": "application/json",
                "Authorization": UserInfo.shared.accessToken
            ]
        }
    }
}