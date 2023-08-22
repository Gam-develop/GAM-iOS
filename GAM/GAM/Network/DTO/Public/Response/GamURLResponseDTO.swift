//
//  GamURLResponseDTO.swift
//  GAM
//
//  Created by Jungbin on 2023/08/23.
//

import Foundation

struct GamURLResponseDTO: Codable {
    let introURL: String
    let policyURL: String
    let agreementURL: String
    let makersURL: String
    
    enum CodingKeys: String, CodingKey {
        case introURL = "introUrl"
        case policyURL = "policyUrl"
        case agreementURL = "agreementUrl"
        case makersURL = "makersUrl"
    }
    
    public func toEntity() -> GamURLEntity {
        return GamURLEntity(intro: introURL, privacyPolicy: policyURL, agreement: agreementURL, makers: makersURL)
    }
}
