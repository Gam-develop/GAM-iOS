//
//  RefreshTokenResponseDTO.swift
//  GAM
//
//  Created by Jungbin on 1/11/24.
//

import Foundation

struct RefreshTokenResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let isProfileCompleted: Bool
    let id: Int
    let appVersion: String
}
