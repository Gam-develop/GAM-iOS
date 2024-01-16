//
//  RefreshTokenRequestDTO.swift
//  GAM
//
//  Created by Jungbin on 1/11/24.
//

import Foundation

struct RefreshTokenRequestDTO: Encodable {
    let accessToken: String
    let refreshToken: String
}
