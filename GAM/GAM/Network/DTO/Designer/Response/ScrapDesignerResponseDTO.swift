//
//  ScrapDesignerResponseDTO.swift
//  GAM
//
//  Created by Jungbin on 1/10/24.
//

import Foundation

struct ScrapDesignerResponseDTO: Codable {
    let targetUserId: Int
    let userName: String
    let userScrap: Bool
}
