//
//  SocialLoginResponseDTO.swift
//  GAM
//
//  Created by Jungbin on 2023/08/23.
//

import Foundation

struct SocialLoginResponseDTO: Codable {
    let isProfileCompleted: Bool
    let id: Int
    let accessToken: String
    let refreshToken: String
    let appVersion: String

    enum CodingKeys: String, CodingKey {
        case isProfileCompleted = "isProfileCompleted"
        case id = "id"
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
        case appVersion = "appVersion"
    }
}
