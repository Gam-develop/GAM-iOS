//
//  SetPortfolioRequestDTO.swift
//  GAM
//
//  Created by Juhyeon Byun on 1/8/24.
//

import Foundation

struct SetPortfolioRequestDTO: Codable {
    let workId: Int
    
    init(workId: Int) {
        self.workId = workId
    }
}
