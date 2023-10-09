//
//  ScrapMagazineRequestDTO.swift
//  GAM
//
//  Created by Jungbin on 2023/10/09.
//

import Foundation

struct ScrapMagazineRequestDTO: Codable {
    let targetMagazineId: Int
    let currentScrapStatus: Bool
    
    init(targetMagazineId: Int, currentScrapStatus: Bool) {
        self.targetMagazineId = targetMagazineId
        self.currentScrapStatus = currentScrapStatus
    }
}
