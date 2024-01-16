//
//  LogoutRequestDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/17/24.
//

import Foundation

struct LogoutRequestDTO: Encodable {
    let accessToken: String
    let refreshToken: String
}
