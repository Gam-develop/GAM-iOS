//
//  SocialLoginRequestDTO.swift
//  GAM
//
//  Created by Jungbin on 2023/08/23.
//

import Foundation

struct SocialLoginRequestDTO: Encodable {
    let token: String
    let socialType: String
    let deviceToken: String
    
    init(token: String, socialType: SocialType, deviceToken: String) {
        self.token = token
        self.socialType = socialType.rawValue
        self.deviceToken = deviceToken
    }
}
