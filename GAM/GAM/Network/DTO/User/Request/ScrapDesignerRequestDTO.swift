//
//  ScrapDesignerRequestDTO.swift
//  GAM
//
//  Created by Jungbin on 1/10/24.
//

import Foundation

struct ScrapDesignerRequestDTO: Codable {
    let targetUserId: Int
    let currentScrapStatus: Bool
}
