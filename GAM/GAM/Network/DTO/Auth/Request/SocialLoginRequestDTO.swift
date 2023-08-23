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
    
    init(token: String, socialType: SocialType) {
        self.token = token
        self.socialType = socialType.rawValue
    }
}
