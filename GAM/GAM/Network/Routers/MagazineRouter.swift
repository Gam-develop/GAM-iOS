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
    case requestScrapMagazine(data: ScrapMagazineRequestDTO)
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
        case .requestScrapMagazine:
            return "/magazine/scrap"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPopularMagazine, .getAllMagazine, .getScrapMagazine:
            return .get
        case .requestScrapMagazine:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPopularMagazine, .getAllMagazine, .getScrapMagazine:
            return .requestPlain
        case .requestScrapMagazine(let data):
            let body: [String: Any] = [
                "targetMagazineId": data.targetMagazineId,
                "currentScrapStatus": data.currentScrapStatus
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getPopularMagazine, .getAllMagazine, .getScrapMagazine, .requestScrapMagazine:
            return [
                "Content-Type": "application/json",
                "Authorization": UserInfo.shared.accessToken
            ]
        }
    }
}
